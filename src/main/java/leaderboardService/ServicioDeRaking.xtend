package leaderboardService

import runner.Runner
import aereolinea.Destino
import org.hibernate.query.Query
import service.User

class ServicioDeRaking implements LeaderboardService {
	
	override rankingDestinos() {
		Runner.runInSession[ {
			val session = Runner.getCurrentSession
	
		
			var hql = "SELECT c.tramo.destinoLlegada
								FROM Compra c
								GROUP BY c.tramo.destinoLlegada
								ORDER BY count(1) Desc"

			var Query<Destino> query
			
			query = session.createQuery(hql, Destino).setMaxResults(10)
			query.getResultList
		}]
	}
	
	override rankingCompradores() {
		Runner.runInSession[ {
			val session = Runner.getCurrentSession
	
		
			var hql = "SELECT c.comprador
					   FROM  Compra c
					   GROUP BY c.comprador
					   ORDER BY count(1) Desc"
								
			var Query<User> query
			query = session.createQuery(hql, User).setMaxResults(10)
	
		
			query.getResultList
		}]
	}
	
	override rankingPagadores() {
			Runner.runInSession[ {
			val session = Runner.getCurrentSession
	
		
			var hql = "FROM User u
				   	   ORDER BY u.gastoTotal Desc"
								
			var Query<User> query
			query = session.createQuery(hql, User).setMaxResults(10)
	
		
			query.getResultList
		}]
	}
}
	
