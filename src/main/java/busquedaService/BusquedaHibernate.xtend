package busquedaService

import service.User
import runner.Runner
import org.hibernate.query.Query
import aereolinea.Asiento
import Busqueda.Busqueda
import daoImplementacion.HibernateUserDAO

class BusquedaHibernate implements BusquedaService{
	
	override buscar(Busqueda busqueda, User usuario) {
		
		val session = Runner.getCurrentSession
		
		var hql = "FROM Asiento a" +
		" WHERE " + busqueda.filtro +
		" ORDER BY " + busqueda.criterio + " " + busqueda.orden
		
		var Query<Asiento> query = session.createQuery(hql,  Asiento)
		
		val userDAO = new HibernateUserDAO
		usuario.agregarBusqueda(busqueda)
		
		Runner.runInSession[ {

			userDAO.update(usuario)
			null
		}]
		
		return query.getResultList

	}
	
	override list(User usuario) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override busquedasGuardada(Busqueda busqueda, User usuario) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}