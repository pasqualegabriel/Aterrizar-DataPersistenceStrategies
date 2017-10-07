package daoImplementacion

import service.User
import org.eclipse.xtend.lib.annotations.Accessors
import java.sql.Connection
import java.sql.SQLException
import java.sql.DriverManager
import org.eclipse.xtext.xbase.lib.Functions.Function1
import java.sql.PreparedStatement
import java.util.Date
import dao.UserDAO

@Accessors
class JDBCUserDAO implements UserDAO{
	
	new() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new RuntimeException("No se puede encontrar la clase del driver", e);
		}
	}
	
	def prepareStatement(User aUser, String aPrepareStatement, Boolean isUpdate){
		this.executeWithConnection([conn | 				
			var ps = conn.prepareStatement(aPrepareStatement)
			ps.setString( 1, aUser.name)
			ps.setString( 2, aUser.lastName)
			ps.setString( 3, aUser.userName)
			ps.setString( 4, aUser.userPassword)
			ps.setString( 5, aUser.mail)
			ps.setLong(   6, aUser.birthDate.time)
			ps.setBoolean(7, aUser.validate)
			ps.setString( 8, aUser.validateCode)
			
			if(isUpdate){
				ps.setString( 9, aUser.userName)
			}
			
			ps.execute
			ps.close
			null
		])
		
	}

	override void save(User aUser) {
		
		prepareStatement(aUser, "INSERT INTO user (firstName, lastName, userName, pasword, mail, birthDate, validate, validateCode) VALUES (?,?,?,?,?,?,?,?)", false)

	}	
	
	override update(User aUser) {
 				
		prepareStatement(aUser,"UPDATE user SET firstName = ?, lastName = ?, userName = ?, pasword = ?, mail = ?, birthDate = ?, validate = ?, validateCode = ? WHERE userName = ?", true)
	
	}	
	
	override load(User oneUser) {
		
		return this.executeWithConnection([conn |
			var filters = newArrayList(
				"firstName"   -> new StringEvaluator(oneUser.name),
				"lastName"    -> new StringEvaluator(oneUser.lastName),
				"userName"    -> new StringEvaluator(oneUser.userName),
				"pasword"     -> new StringEvaluator(oneUser.userPassword),
				"mail"        -> new StringEvaluator(oneUser.mail),
				"birthDate"   -> new DateEvaluator(oneUser.birthDate),
				"validate"    -> new BooleanEvaluator(oneUser.validate),
				"validateCode"-> new StringEvaluator(oneUser.validateCode)
			).filter[pair| pair.value.value != null]
			
			val filterCondition = new StringBuilder()
			filters.forEach[pair|
				val column = pair.key
				if(!filterCondition.toString.equals("")){
					filterCondition.append("and ")
				}
				filterCondition.append(column + " = ? " )
			]
			var ps = conn.prepareStatement("SELECT * FROM user WHERE " + filterCondition.toString);
			
			for (var i=0; i< filters.size; i++) {
				filters.get(i).value.evaluate(ps, i+1)
			}
			

			var resultSet = ps.executeQuery();

			var User aUser = null;
			if (resultSet.next()) {
			
				//si personaje no es null aca significa que el while dio mas de una vuelta, eso
				//suele passar cuando el resultado (resultset) tiene mas de un elemento.
				if (aUser != null) {
					throw new RuntimeException("Existe mas de un user")
				}
				
				
				aUser              = new User
				aUser.name         = resultSet.getString("firstName")
				aUser.lastName     = resultSet.getString("lastName")
				aUser.userName     = resultSet.getString("userName")
				aUser.userPassword = resultSet.getString("pasword")
				aUser.mail         = resultSet.getString("mail")
				aUser.birthDate    = new Date(resultSet.getLong("birthDate"))
				aUser.validate     = resultSet.getBoolean("validate")
				aUser.validateCode = resultSet.getString("validateCode")
			}
			
			ps.close
		    aUser
		])
	}
		
	/**
	 * Ejecuta un bloque de codigo contra una conexion.
	 */
	def <T> T executeWithConnection(Function1<Connection, T> bloque) {
		var connection = this.openConnection("jdbc:mysql://localhost:8889/epers-1?user=root&password=root");
		try {
			return bloque.apply(connection);
		} catch (SQLException e) {
			throw new RuntimeException("Error no esperado", e);
		} finally {
			this.closeConnection(connection);
		}
	}

	/**
	 * Establece una conexion a la url especificada
	 * @param url - la url de conexion a la base de datos
	 * @return la conexion establecida
	 */
	def Connection openConnection(String url) {
		try {
			//La url de conexion no deberia estar harcodeada aca
			return DriverManager.getConnection("jdbc:mysql://localhost:3306/a_cara_de_perro_aterrizar?user=persistencia&password=persistencia");
		} catch (SQLException e) {
			throw new RuntimeException("No se puede establecer una conexion", e);
		}
	}

	/**
	 * Cierra una conexion con la base de datos (libera los recursos utilizados por la misma)
	 * @param connection - la conexion a cerrar.
	 */
	def void closeConnection(Connection connection) {
		try {
			connection.close();
		} catch (SQLException e) {
			throw new RuntimeException("Error al cerrar la conexion", e);
		}
	}
	
	override clearAll() {
		this.executeWithConnection([conn | 
			var ps = conn.prepareStatement("DElETE FROM user")
			ps.execute
			ps.close

			null	
		])
	}
	
	@Accessors
	static abstract class Evaluator<T>{
		public T value
		
		new(T value){
			this.value = value
		}
		
		def void evaluate(PreparedStatement ps, int index)
	}
	
	static class StringEvaluator extends Evaluator<String>{
		
		new(String value){
			super(value)
		}
		
		override evaluate(PreparedStatement ps, int index) {
			ps.setString(index, value)
		}
		
	}
	static class BooleanEvaluator extends Evaluator<Boolean>{
		
		new(Boolean value){
			super(value)
		}
		
		override evaluate(PreparedStatement ps, int index) {
			ps.setBoolean(index, value)
		}
		
	}
	static class DateEvaluator extends Evaluator<Date>{
		
		new(Date value){
			super(value)
		}
		
		override evaluate(PreparedStatement ps, int index) {
			ps.setLong(index, value.time)
		}
		
	}
}
		