package service

import dao.UserDAO
import mailSender.EmailService
import runner.Runner
import org.hibernate.query.Query
import java.util.Date

class ServiceHibernate extends ServiceJDBC {

	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		super(userDao, unGeneradorDeMail, unGeneradorDeCodigo, unMailService)
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
		
		var user = searchUserForUserNameAndMail(userName, mail)
		
		user != null	 
	}
	
	def searchUserForUserNameAndMail(String userName, String mail) {

		searchUserHibernate("FROM User u WHERE u.mail = '" + mail + "'" + " or u.userName = '" + userName + "'")

	}

	override searchUserForUserNameAndPassword(String userName, String oldPassword){

		searchUserHibernate( "FROM User u WHERE u.userPassword = '" + oldPassword + "'" + " and u.userName = '" + userName + "'") 

	}

	def searchUserForMail(String mail) {
	
		searchUserHibernate("FROM User u WHERE u.mail = '" + mail + "'")

	}
	
	override searchUserForCode(String code) {

		searchUserHibernate("FROM User u WHERE u.validateCode = '" + code + "'")
	}
	
	
	def searchUserHibernate(String queryHql) {

		val Query<User> query = Runner.getCurrentSession.createQuery(queryHql, User)
		val result = query.getResultList
		
		if(result.size == 0){
			return null
		}
		result.get(0)
	}





}



