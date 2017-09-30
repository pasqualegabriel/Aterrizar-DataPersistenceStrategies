package service

import org.eclipse.xtend.lib.annotations.Accessors

import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords
import java.util.Date
import mailSender.EmailService
import Excepciones.ExceptionUsuarioExistente
import dao.UserDAO

@Accessors
class Service implements UserService {

	UserDAO	      userDAO
	EmailService  mailSender
	MailGenerator generadorDeMail
	CodeGenerator generadorDeCodigo
	
	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		userDAO           = userDao
		mailSender		  = unMailService
		generadorDeMail   = unGeneradorDeMail
		generadorDeCodigo = unGeneradorDeCodigo
		
	}

	override singUp(String name, String lastName, String userName, String mail, String password, Date birthDate) {
		
		if(this.existeUsuarioCon(userName, mail)) {
			throw new ExceptionUsuarioExistente("no se puede registrar el Usuario")
		} 
		
		var usuario          = new User(name, lastName, userName, mail, password, birthDate)
		var codigo 		     = generadorDeCodigo.generarCodigo
		var validationCode   = codigo + userName
		usuario.validateCode = validationCode
		var aMail            = generadorDeMail.generarMail(validationCode, mail)
		mailSender.send(aMail)
		userDAO   .save(usuario)
		usuario
		
		
	}
	


	override validate(String code) {
		
			var userExample    	     = new User()
			userExample.validateCode = code
			var user             	 = userDAO.load(userExample)
			
			isUserNull(user,new InvalidValidationCode("El codigo no es correcto"))
			
			user.validateAccount
			userDAO.update(user)
			true		
	}

	override signIn(String username, String password) {
		
		val userExample				= new User	
		userExample.userName 		= username
		userExample.userPassword 	= password
		  
		var user = userDAO.load(userExample)
		  
		if(user== null || !user.validate){
			throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos")
		}
		user 

	}
	
	override changePassword(String userName, String oldPassword, String newPassword) {
		if (oldPassword.equals(newPassword)) throw new IdenticPasswords("Las contraseñas no tienen que ser las mismas")
					
		val userExample		 = new User 
		userExample.userName = userName
	
		var user = userDAO.load(userExample)
		isUserNull(user,new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos"))
	
		user.userPassword = newPassword
		
		userDAO.update(user)
		
		
	
	}
	
	def void isUserNull(User user, RuntimeException exception) {
		if(user==null) throw exception
	}
	

	


	def existeUsuarioCon(String userName, String mail){
		var userExampleWithUserName	 = new User
		var userExampleWithMail		 = new User
		userExampleWithMail.userName = userName
		userExampleWithUserName.mail = mail	
		var userNick = userDAO.load(userExampleWithMail)
		var userMail = userDAO.load(userExampleWithUserName)
		userNick != null || userMail != null
	}

 
}
