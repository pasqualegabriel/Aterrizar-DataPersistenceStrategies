package busquedaService

import runner.Runner
import org.hibernate.query.Query
import aereolinea.Asiento
import Busqueda.Busqueda
import dao.BusquedaDAO
import daoImplementacion.HibernateBusquedaDAO
import daoImplementacion.HibernateUserDAO

class BusquedaHibernate implements BusquedaService{
	BusquedaDAO busquedaDAO
	HibernateUserDAO     userDAO
	new(){
		busquedaDAO = new HibernateBusquedaDAO
		userDAO     = new HibernateUserDAO
	}
	
	override buscar(Busqueda busqueda, String usuario) {
		Runner.runInSession[ {
			
			var user = userDAO.loadbyname(usuario)
			val session = Runner.getCurrentSession
			busqueda.setUsuario(user)
	
			var hql = "FROM Asiento a" +
			" WHERE " + busqueda.queryFiltro +
			" ORDER BY " + busqueda.queryCriterio + " " + busqueda.queryOrden 
		
			var Query<Asiento> query = session.createQuery(hql,  Asiento)
	
			busquedaDAO.save(busqueda)
		
			query.getResultList
		}]
			
	}

	override list(String userName) {
		Runner.runInSession[ {
			val session = Runner.getCurrentSession
          
        	var hql = "from Busqueda b where b.user.userName = '" + userName + "' order by b.id desc"

			var Query<Busqueda> query =  session.createQuery(hql, Busqueda).setMaxResults(10)
			query.getResultList
		}]
		
	}
		
	
	
	override busquedasGuardada(Integer busqueda, String usuario) {
		

		
	}
	
	
	
}