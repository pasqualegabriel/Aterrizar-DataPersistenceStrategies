package userDAO

import service.User
import runner.Runner
import runner.SessionFactoryProvider
import org.hibernate.Session

class HibernateUserDAO implements UserDAO {
	
	override save(User oneUser) {
		val Session session = Runner.currentSession
		session.save(oneUser)
	}
	
	override load(User aUser) {
		var session = Runner.currentSession
		session.get(User, aUser.name)
	}
	
	override update(User oneUser) {
		
	}
	
	override clearAll() {
		SessionFactoryProvider.destroy
	}
	
}