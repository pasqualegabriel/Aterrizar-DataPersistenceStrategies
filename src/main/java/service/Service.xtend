package service

import org.eclipse.xtend.lib.annotations.Accessors
import userDAO.UserDAO
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords
import mailSender.Mail
import mailSender.Postman
import java.util.Date

@Accessors
class Service implements UserService {

	UserDAO	userDAO
	Postman	mailSender

	new(UserDAO userDao) {
		userDAO    = userDao
		mailSender = new Postman
		
	}

	override singUp(String name, String lastName, String userName, String mail, String password, Date birthDate) {
		
		if(this.existeUsuarioCon(userName, mail)) {
			throw new RuntimeException("no se puede registrar el Usuario")
		} 
		else {
			var usuario        = new User(name, lastName, userName, mail, password, birthDate)
			var aleatorio      = "1234567890"
			var validationCode = aleatorio + userName
			var body           = "este es tu codigo de validacion " + validationCode
			var aMail          = new Mail("Validacion de cuenta ", body , mail, "AterrizarAdmin@gmail.com")
			mailSender.send(aMail)
			userDAO.save(usuario)
			usuario
		}
		
	}

	override validate(String code) {
		// Preguntar por que devuelve true si en caso de no ser valido levanta excepcion, no devuelve nunca false
		try {
			var userExample      = new User()
			var userName         = code.substring(10, code.length) 
			userExample.userName = userName
			var user             = userDAO.load(userExample)
			user.validate        = true
			userDAO.update(user)
			true
		} 
		catch (RuntimeException e) {
			throw new InvalidValidationCode("El codigo no es correcto")
		}
	}

	override signIn(String username, String password) {
		
		val userExample				= new User	
		userExample.userName 		= username
		userExample.userPassword 	= password
		  
		var user = userDAO.load(userExample)
		  
		if(user != null && user.validate){
			
			user
		} 
		else{
			throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos")		  	
		}
	}
	
	override changePassword(String userName, String oldPassword, String newPassword) {
		// Se valida que las passwords no sean identicas
		if (oldPassword.equals(newPassword)) throw new IdenticPasswords("Las contraseñas no tienen que ser las mismas")
		
		try {
			
			val userExample		 = new User 
			userExample.userName = userName
			
			// Intenta buscar al usuario con ese nombre y el password viejo
			var user = userDAO.load(userExample)
			// una vez lo encuentra, le setea el nuevo password
			user.userPassword = newPassword
			// y finalmente persiste los cambios al usuario
			userDAO.update(user)
			
		} catch (RuntimeException  e)  { // De levantar una excepcion el dao al hacer load al usuario
			// tira una excepcion explicando que el usuario o la contraseña no son correctos
			throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos")
		}
	
	}

	def existeUsuarioCon(String userName, String mail) {

		var userExample		 = new User
		userExample.userName = userName
		userExample.mail     = mail	
		var user = userDAO.load(userExample)
		user != null
	}


}
