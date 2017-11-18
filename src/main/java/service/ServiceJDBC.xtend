package service

import dao.UserDAO
import mailSender.EmailService

class ServiceJDBC extends ServiceUser {
	
	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		super(userDao, unGeneradorDeMail, unGeneradorDeCodigo, unMailService)
	}
	
	override searchUserForCode(String code) {
		var userExample    	     = new User()
		userExample.validateCode = code
		loadUser(userExample)
	}
		
	override searchUserForUserNameAndPassword(String userName, String password){
		
		val userExample		 	 = new User 
		userExample.userName 	 = userName
		userExample.userPassword = password
	
		loadUser(userExample)
	}

	override existeUsuarioCon(String userName, String mail){
		var userExampleWithUserName	 	 = new User
		var userExampleWithMail		 	 = new User
		userExampleWithUserName.userName = userName
		userExampleWithMail.mail		 = mail	
		var userNick = loadUser(userExampleWithMail)
		var userMail = loadUser(userExampleWithUserName)
		userNick != null || userMail != null
		
	}

}




