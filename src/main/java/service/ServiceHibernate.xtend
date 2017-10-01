package service

import dao.UserDAO
import mailSender.EmailService
import runner.Runner

class ServiceHibernate extends Service {

	new(UserDAO userDao, MailGenerator unGeneradorDeMail, CodeGenerator unGeneradorDeCodigo,
		EmailService unMailService) {
		super(userDao, unGeneradorDeMail, unGeneradorDeCodigo, unMailService)
	}

	override void saveUser(User aUser) {
		Runner.runInSession [
			{
				userDAO.save(aUser)
				null
			}
		]
	}

	override void updateUser(User aUser) {
		Runner.runInSession [
			{
				userDAO.update(aUser)
				null
			}
		]
	}

	override User loadUser(User aUser) {
		
		Runner.runInSession[{ userDAO.load(aUser)}]	
	}
	

}
