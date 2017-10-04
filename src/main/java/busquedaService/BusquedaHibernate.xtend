package busquedaService

import service.User
import runner.Runner
import org.hibernate.query.Query
import aereolinea.Asiento
import Busqueda.Busqueda
import dao.BusquedaDAO
import daoImplementacion.HibernateBusquedaDAO

class BusquedaHibernate implements BusquedaService{
	BusquedaDAO busquedaDAO
	
	new(){
		busquedaDAO= new HibernateBusquedaDAO
	}
	
	override buscar(Busqueda busqueda, User usuario) {
		Runner.runInSession[ {
			
			val session = Runner.getCurrentSession
			busqueda.setUsuario(usuario)
	
			var hql = "FROM Asiento a" +
			" WHERE " + busqueda.queryFiltro +
			" ORDER BY " + busqueda.queryCriterio + " " + busqueda.queryOrden 
		
			var Query<Asiento> query = session.createQuery(hql,  Asiento)
	
			busquedaDAO.save(busqueda)
		
			query.getResultList
		}]
			
	}

	override list(User usuario) {
		Runner.runInSession[ {
			val session = Runner.getCurrentSession
          
        	var hql = "from Busqueda b where b.user.userName = '" + usuario.userName + "' order by b.id desc"

			var Query<Busqueda> query =  session.createQuery(hql, Busqueda).setMaxResults(10)
			query.getResultList
		}]
		
	}
		
	
	
	override busquedasGuardada(Busqueda busqueda, User usuario) {
		

		
	}
	
	
	
}