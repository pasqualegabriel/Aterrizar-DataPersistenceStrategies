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
		var userExampleWithUserName	 = new User
		userExampleWithUserName.userName = userName
		var user = loadUser(userExampleWithUserName)
		
		var User userMail = searchUserForMail(mail)
		
		userMail != null || user != null
	}
	
	def searchUserForMail(String mail) {
		Runner.runInSession[{
			
			val session = Runner.getCurrentSession
		
			var hql = "FROM User u WHERE u.mail = '" + mail + "'"
		
			var Query<User> query =  session.createQuery(hql, User)
			
			if(query.getResultList.size == 0){
				return null
			}
			return query.resultList.get(0)
		}]
	}
	
	override searchUserForCode(String code) {
		Runner.runInSession[{
			
			val session = Runner.getCurrentSession
		
			var hql = "FROM User u WHERE u.validateCode = '" + code + "'"
		
			var Query<User> query =  session.createQuery(hql, User)
			
			if(query.getResultList.size == 0){
				return null
			}
			return query.resultList.get(0)
		}]
	}





}




