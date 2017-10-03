package service

import dao.UserDAO
import mailSender.EmailService
import runner.Runner
import org.hibernate.query.Query

class ServiceHibernate extends Service {

	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo, EmailService unMailService) {
		super(userDao, unGeneradorDeMail, unGeneradorDeCodigo, unMailService)
	}

	override void saveUser(User aUser) {
		Runner.runInSession [{
			userDAO.save(aUser)
			null
		}]
	}

	override void updateUser(User aUser) {
		Runner.runInSession [{
			userDAO.update(aUser)
			null
		}]
	}

	override User loadUser(User aUser) {
		Runner.runInSession[{
			userDAO.load(aUser)
		}]	
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
		Runner.runInSession[{
			
			val session = Runner.getCurrentSession
		
			var hql = queryHql
		
			var Query<User> query =  session.createQuery(hql, User)
			
			if(query.getResultList.size == 0){
				return null
			}
			return query.resultList.get(0)
		}]
	}





}




