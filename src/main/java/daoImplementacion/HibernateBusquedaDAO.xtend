package daoImplementacion

import dao.BusquedaDAO
import Busqueda.Busqueda
import org.hibernate.Session
import runner.Runner
import runner.SessionFactoryProvider

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
	

	
}