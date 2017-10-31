package busquedaService

import runner.Runner
import Busqueda.Busqueda
import dao.BusquedaDAO
import daoImplementacion.HibernateBusquedaDAO
import daoImplementacion.HibernateUserDAO

class BusquedaHibernate implements BusquedaService{
	
	BusquedaDAO      busquedaDAO
	HibernateUserDAO userDAO
	
	new(){
		
		busquedaDAO = new HibernateBusquedaDAO
		userDAO     = new HibernateUserDAO
	}
	
	override buscar(Busqueda busqueda, String usuario) {
		
		Runner.runInSession[
			
			var user = userDAO.loadbyname(usuario)
			busqueda.setUsuario(user)
			busquedaDAO.save(busqueda)
			
			busquedaDAO.buscarAsientosDisponibles(busqueda).filter[it.estaDisponible].toList
		
//			val session = Runner.getCurrentSession
//			var Query<Asiento> query = queryHqlBusqueda(session, busqueda)
//		
//			query.getResultList.filter[it.estaDisponible].toList
		]
			
	}
	
//	def queryHqlBusqueda(Session session, Busqueda busqueda) {
//
//		var hql = "FROM Asiento a" +
//			" WHERE " + busqueda.queryFiltro +
//			" ORDER BY " + busqueda.queryCriterio + " " + busqueda.queryOrden 
//		
//		session.createQuery(hql,  Asiento)
//	}

	override list(String userName) {
		
		Runner.runInSession[
			
			busquedaDAO.ultimasDiezBusquedasRealizadas(userName)
		
//			val session = Runner.getCurrentSession
//          
//        	var hql = "from Busqueda b where b.user.userName = '" + userName + "' order by b.id desc"
//
//			var Query<Busqueda> query = session.createQuery(hql, Busqueda).setMaxResults(10)
//			query.getResultList
		]
		
	}
	
	override busquedasGuardada(Integer busqueda, String usuario) {
		
		Runner.runInSession[
			
			var busquedaUser = busquedaDAO.loadById(busqueda)
			
			busquedaDAO.buscarAsientosDisponibles(busquedaUser)
			
//			val session = Runner.getCurrentSession
//			var Query<Asiento> query = queryHqlBusqueda(session, busquedaUser)
//		
//			query.getResultList
		]
		
	}
	
	
	
}