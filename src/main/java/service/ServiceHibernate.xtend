package service

import mailSender.EmailService
import runner.Runner
import java.util.Date
import daoImplementacion.HibernateUserDAO

class ServiceHibernate extends ServiceUser {
	
	HibernateUserDAO hibernateUserDAO

	new(HibernateUserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		super(userDao, unGeneradorDeMail, unGeneradorDeCodigo, unMailService)
		hibernateUserDAO = userDao
	}
	
	override singUp(String name, String lastName, String userName, String mail, String userPassword, Date birthDate) {
		Runner.runInSession[
			super.singUp(name, lastName, userName, mail, userPassword, birthDate)
		]
	}

	override validate(String code){
		Runner.runInSession[
			super.validate(code)
		]
	}

	override signIn(String username, String password){
		Runner.runInSession[
			super.signIn(username, password)
		]
	}

	override changePassword(String username, String oldPassword, String newPassword){
		Runner.runInSession[
			super.changePassword(username, oldPassword, newPassword)
			null
		]
	}

	override existeUsuarioCon(String userName, String mail){
		
		var user = hibernateUserDAO.searchUserForUserNameAndMail(userName, mail)
		
		user != null	 
	}
	
	def searchUserForUserNameAndMail(String userName, String mail) {

		hibernateUserDAO.searchUserForUserNameAndMail(userName, mail)
	}

	override searchUserForUserNameAndPassword(String userName, String oldPassword){

		hibernateUserDAO.searchUserForUserNameAndPassword(userName, oldPassword)
	}
	
	override searchUserForCode(String code) {

		hibernateUserDAO.searchUserForCode(code)
	}



}



