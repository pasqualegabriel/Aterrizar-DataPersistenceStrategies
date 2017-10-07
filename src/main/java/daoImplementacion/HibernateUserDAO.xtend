package daoImplementacion

import service.User
import runner.Runner
import runner.SessionFactoryProvider
import org.hibernate.Session
import dao.UserDAO

class HibernateUserDAO implements UserDAO {
	
	override save(User oneUser) {
		val Session session = Runner.currentSession
		session.save(oneUser)
	}
	
	override load(User aUser) {
		var session = Runner.currentSession
		session.get(User, aUser.userName)
	}
	
	override update(User oneUser) {
		val session = Runner.getCurrentSession
		session.update(oneUser)
	}
	
	override clearAll() {
		SessionFactoryProvider.destroy
	}
	
	def loadbyname(String userName) {
		var session = Runner.currentSession
		session.get(User, userName)
	}
	
}
