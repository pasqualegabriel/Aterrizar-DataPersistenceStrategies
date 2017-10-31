package daoImplementacion

import dao.BusquedaDAO
import Busqueda.Busqueda
import org.hibernate.Session
import runner.Runner
import runner.SessionFactoryProvider
import aereolinea.Asiento
import org.hibernate.query.Query

class HibernateBusquedaDAO implements BusquedaDAO {
	
	override save(Busqueda aSearch) {
		val Session session = Runner.currentSession
		session.save(aSearch)
	}
	
	override load(Busqueda aSearch) {		
		var session = Runner.currentSession
		session.get(Busqueda, aSearch.id)
	}
	
	override loadById(Integer busqueda) {
		
		var session = Runner.currentSession
		session.get(Busqueda, busqueda)
	}

	override clearAll() {
		SessionFactoryProvider.destroy
	}
	
	override buscarAsientosDisponibles(Busqueda busqueda) {
		
		val session = Runner.getCurrentSession
		var Query<Asiento> query = queryHqlBusqueda(session, busqueda)
		
		query.getResultList
	}
	
	def queryHqlBusqueda(Session session, Busqueda busqueda) {

		var hql = "FROM Asiento a" +
			" WHERE " + busqueda.queryFiltro +
			" ORDER BY " + busqueda.queryCriterio + " " + busqueda.queryOrden 
		
		session.createQuery(hql,  Asiento)
	}
	
	override ultimasDiezBusquedasRealizadas(String userName) {
		
		val session = Runner.getCurrentSession
      
    	var hql = "from Busqueda b where b.user.userName = '" + userName + "' order by b.id desc"

		var Query<Busqueda> query = session.createQuery(hql, Busqueda).setMaxResults(10)
		query.getResultList
	}

	
}