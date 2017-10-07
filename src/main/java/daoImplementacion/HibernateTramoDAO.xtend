package daoImplementacion

import dao.TramoDAO
import aereolinea.Tramo
import runner.Runner
import org.hibernate.Session

class HibernateTramoDAO implements TramoDAO{
	
	override save(Tramo unTramo) {
		val Session session = Runner.currentSession
		session.save(unTramo)
	}
	
	override load(Integer unTramo) {
		var session = Runner.currentSession
		session.get(Tramo, unTramo)
	}
	
}