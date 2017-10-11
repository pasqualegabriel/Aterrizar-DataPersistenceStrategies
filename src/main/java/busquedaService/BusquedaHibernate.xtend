package busquedaService

import runner.Runner
import org.hibernate.query.Query
import aereolinea.Asiento
import Busqueda.Busqueda
import dao.BusquedaDAO
import daoImplementacion.HibernateBusquedaDAO
import daoImplementacion.HibernateUserDAO
import org.hibernate.Session

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
			val session = Runner.getCurrentSession
			busqueda.setUsuario(user)
		
			var Query<Asiento> query = queryHqlBusqueda(session, busqueda)
	
			busquedaDAO.save(busqueda)
		
			query.getResultList
		]
			
	}
	
	def queryHqlBusqueda(Session session, Busqueda busqueda) {

		var hql = "FROM Asiento a" +
			" WHERE " + busqueda.queryFiltro +
			" ORDER BY " + busqueda.queryCriterio + " " + busqueda.queryOrden 
		
		session.createQuery(hql,  Asiento)
	}

	override list(String userName) {
		
		Runner.runInSession[
		
			val session = Runner.getCurrentSession
          
        	var hql = "from Busqueda b where b.user.userName = '" + userName + "' order by b.id desc"

			var Query<Busqueda> query =  session.createQuery(hql, Busqueda).setMaxResults(10)
			query.getResultList
		]
		
	}
	
	override busquedasGuardada(Integer busqueda, String usuario) {
		
		Runner.runInSession[
			
			val session = Runner.getCurrentSession
			var busquedaUser = busquedaDAO.loadById(busqueda)
			
//			if(busquedaUser.user.userName != usuario){
//				throw new ExceptionBusquedaUser("La busqueda no fue realizada por el usuario")
//			}
		
			var Query<Asiento> query = queryHqlBusqueda(session, busquedaUser)
		
			query.getResultList
		]
		
	}
	
	
	
}