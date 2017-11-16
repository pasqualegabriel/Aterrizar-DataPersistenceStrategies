package service

import java.util.Date
import dao.UserDAO
import daoImplementacion.UserNeo4jDAO
import mailSender.EmailService
import org.eclipse.xtend.lib.annotations.Accessors
import Excepciones.ExceptionUsuarioExistente
import Excepciones.InvalidValidationCode
import Excepciones.IdenticPasswords
import Excepciones.IncorrectUsernameOrPassword
import daoImplementacion.ProfileDAO

@Accessors
abstract class ServiceUser implements UserService {
	
	UserDAO  			userDAO
	UserNeo4jDAO  		userNeo4JDAO
	EmailService  	    mailSender
	MailGenerator	    generadorDeMail
	CodeGenerator 	    generadorDeCodigo
	ProfileDAO 			profileDAO
	
	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		userDAO           = userDao
		userNeo4JDAO      = new UserNeo4jDAO
		mailSender		  = unMailService
		generadorDeMail   = unGeneradorDeMail
		generadorDeCodigo = unGeneradorDeCodigo
		profileDAO		  = new ProfileDAO
	}
	
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
		saveUser(usuario)
		usuario
	}
	
	override validate(String code) {
		
		var user = searchUserForCode(code)
			
		isUserNull(user,new InvalidValidationCode("El codigo no es correcto"))
			
		user.validateAccount
		updateUser(user)
		true		
	}
	
	def User searchUserForCode(String code)
	
	override signIn(String username, String password) {
		  
		var user = searchUserForUserNameAndPassword(username, password)
		  
		if(user== null || !user.validate){
			throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos")
		}
		user 
	}
	
	override changePassword(String userName, String oldPassword, String newPassword) {
		
		if (oldPassword.equals(newPassword)) {
	    	throw new IdenticPasswords("Las contraseñas no tienen que ser las mismas")
	    }
	
		var user = searchUserForUserNameAndPassword(userName, oldPassword)
		
		isUserNull(user,new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos"))

		user.userPassword = newPassword
		
		updateUser(user)
	}
	
	def User searchUserForUserNameAndPassword(String userName, String password)
	
	def void isUserNull(User user, RuntimeException exception) {
		if(user==null) throw exception
	}

	def boolean existeUsuarioCon(String userName, String mail)
	
	def User loadUser(User aUser) {
		userDAO.load(aUser)
	}
 
	def void saveUser(User aUser){
		userDAO.save(aUser)
		userNeo4JDAO.save(aUser)
		var perfil = new Profile(aUser.userName)
		profileDAO.save(perfil)
	}
		
	def void updateUser(User aUser) {
		userDAO.update(aUser)
	}
	
	
}