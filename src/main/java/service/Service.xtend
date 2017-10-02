package service

import dao.UserDAO
import mailSender.EmailService
import Excepciones.ExceptionUsuarioExistente
import java.util.Date
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords
import Excepciones.InvalidValidationCode

class Service implements UserService {
	
	protected UserDAO userDAO
	EmailService  	  mailSender
	MailGenerator	  generadorDeMail
	CodeGenerator 	  generadorDeCodigo
	
	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		userDAO           = userDao
		mailSender		  = unMailService
		generadorDeMail   = unGeneradorDeMail
		generadorDeCodigo = unGeneradorDeCodigo
		
	}
	
	//en una abtrascta solo se redifine el save
	override singUp(String name, String lastName, String userName, String mail, String password, Date birthDate) {
		
		if(existeUsuarioCon(userName, mail)) {
			throw new ExceptionUsuarioExistente("no se puede registrar el Usuario")
		} 
		var usuario          = new User(name, lastName, userName, mail, password, birthDate)
		var codigo 		     = generadorDeCodigo.generarCodigo
		var validationCode   = codigo + userName
		usuario.validateCode = validationCode
		var aMail            = generadorDeMail.generarMail(validationCode, mail)
		mailSender.send(aMail)
		saveUser(usuario)//flag
		usuario
	}
	
	//abtracta y se redifine su load y update
	override validate(String code) {
		
			var user = searchUserForCode(code) //redefinir
			
			isUserNull(user,new InvalidValidationCode("El codigo no es correcto"))
			
			user.validateAccount
			updateUser(user)
			true		
	}
	
	def searchUserForCode(String code) {
		var userExample    	     = new User()
		userExample.validateCode = code
		loadUser(userExample)//flag
	}
	
	//a la abtracta solo se redifine su userDao load
	override signIn(String username, String password) {
		
		val userExample				= new User	
		userExample.userName 		= username
		userExample.userPassword 	= password
		  
		var user = loadUser(userExample)//flag
		  
		if(user== null || !user.validate){
			throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos")
		}
		user 
	}
	
	override changePassword(String userName, String oldPassword, String newPassword) {
		
		if (oldPassword.equals(newPassword)) {
	    	throw new IdenticPasswords("Las contraseñas no tienen que ser las mismas")
	    }
		//HABLAR
		val userExample		 	 = new User 
		userExample.userName 	 = userName
		userExample.userPassword = oldPassword
	
		var user = loadUser(userExample)//flag
		
		isUserNull(user,new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos"))

		user.userPassword = newPassword
		
		updateUser(user)//flag	
	}
	
	def void isUserNull(User user, RuntimeException exception) {
		if(user==null) throw exception
	}

	def existeUsuarioCon(String userName, String mail){
		var userExampleWithUserName	 = new User
		var userExampleWithMail		 = new User
		userExampleWithMail.userName = userName
		userExampleWithUserName.mail = mail	
		var userNick = loadUser(userExampleWithMail)
		var userMail = loadUser(userExampleWithUserName)
		userNick != null || userMail != null
		
	}
	
	def User loadUser(User aUser) {
		userDAO.load(aUser)
	}
 
	def void saveUser(User aUser){
		userDAO.save(aUser)
	}
		
	def void updateUser(User aUser) {
		userDAO.update(aUser)
	}
	
	
}




