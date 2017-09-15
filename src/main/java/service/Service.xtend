package service

import org.eclipse.xtend.lib.annotations.Accessors
import userDAO.UserDAO
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords
import java.util.Date
import mailSender.EmailService

@Accessors
class Service implements UserService {

	UserDAO	userDAO
	EmailService	mailSender
	MailGenerator generadorDeMail
	CodeGenerator generadorDeCodigo
	
	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		userDAO    = userDao
		mailSender = unMailService
		generadorDeMail = unGeneradorDeMail
		generadorDeCodigo= unGeneradorDeCodigo
		
	}

	override singUp(String name, String lastName, String userName, String mail, String password, Date birthDate) {
		
		if(this.existeUsuarioCon(userName, mail)) {
			throw new RuntimeException("no se puede registrar el Usuario")
		} 
		else {
			var usuario          = new User(name, lastName, userName, mail, password, birthDate)
			var codigo 		     = generadorDeCodigo.generarCodigo
			var validationCode   = codigo + userName
			usuario.validateCode = validationCode
			var aMail            = generadorDeMail.generarMail(validationCode, mail)
			mailSender.send(aMail)
			userDAO   .save(usuario)
			usuario
		}
		
	}
	


	override validate(String code) {
		try {
			var userExample    	     = new User()
			userExample.validateCode = code
			var user             	 = userDAO.load(userExample)
			user.validate       	 = true
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
