package daoImplementacion

import service.User
import runner.Runner
import runner.SessionFactoryProvider
import org.hibernate.Session
import dao.UserDAO
import aereolinea.Destino

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
	
	def getRankedDestinos() {
		val session = Runner.getCurrentSession
				
		var hql = "SELECT c.tramo.destinoLlegada
							FROM Compra c
							GROUP BY c.tramo.destinoLlegada
							ORDER BY count(1) Desc"

		var query = session.createQuery(hql, Destino).setMaxResults(10)
		query.getResultList
	}
	
	def getRankedCompradores() {
		
		val session = Runner.getCurrentSession

		var hql = "SELECT c.comprador
				   FROM  Compra c
				   GROUP BY c.comprador
				   ORDER BY count(1) Desc"
							
		var query = session.createQuery(hql, User).setMaxResults(10)
		query.getResultList
	}
	
	def getRankedPagadores() {
		val session = Runner.getCurrentSession
	
		var hql = "FROM User u
			   	   ORDER BY u.gastoTotal Desc"
							
		var query = session.createQuery(hql, User).setMaxResults(10)
		query.getResultList
	}
	
}
