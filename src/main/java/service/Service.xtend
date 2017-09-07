package service

import org.eclipse.xtend.lib.annotations.Accessors
import userDAO.UserDAO
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords

@Accessors
class Service implements UserService {

	UserDAO userDAO

	new(UserDAO userDao) {
		userDAO = userDao
	}

	override singUp(String name, String lastName, String userName, String mail, String birthDate) {
		
		if(this.existeUsuarioCon(userName,mail)) {throw new RuntimeException("no se puede registrar el Usuario")} 
		else {
			var usuario = new User(name,lastName,userName,mail,birthDate)
			userDAO.save(usuario)
			/** Falta la parte del mail y de crear el codigo de validacion */
			// this.enviarMailDeRegistracionAUsuario(Usuario usuario, String codigoDeValidacion)
			usuario
		}
		
	}

	override validate(String code) {
		
		try {
			var user = userDAO.loadForCode(code)
			user.validate=true
			userDAO.update(user)
			true
		} catch (RuntimeException e) {throw new InvalidValidationCode("El codigo no es correcto")}
		
		
	}

	override signIn(String username, String password) {
		
		try {// Intenta buscar al usuario con ese nombre y el password
			  userDAO.load(username, password)
			
		} catch (RuntimeException e) { // De levantar una excepcion el dao al hacer load al usuario
			// tira una excepcion explicando que el usuario o la contraseña no son correctos
			throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos")
		}
		
	}
	override changePassword(String username, String oldPassword, String newPassword) {
		// Se valida que las passwords no sean identicas
		if (oldPassword.equals(newPassword)) throw new IdenticPasswords("Las contraseñas no tienen que ser las mismas")
		
		try {
			// Intenta buscar al usuario con ese nombre y el password viejo
			var user = userDAO.load(username, oldPassword)
			// una vez lo encuentra, le setea el nuevo password
			user.pasword= newPassword
			// y finalmente persiste los cambios al usuario
			userDAO.update(user)
			
		} catch (RuntimeException  e)  { // De levantar una excepcion el dao al hacer load al usuario
			// tira una excepcion explicando que el usuario o la contraseña no son correctos
			throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos")
		}
	
	}

	def existeUsuarioCon(String userName, String mail) {

		try {
			// Intenta retornar el usuario sino hace el catch
			userDAO.loadForUsernameAndMail(userName, mail)
			true
			
		} catch (RuntimeException  e) {
			// Si falla, retorna false
			return false
		}
		
	}


}
