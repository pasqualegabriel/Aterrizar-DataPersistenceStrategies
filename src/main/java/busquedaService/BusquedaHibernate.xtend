package busquedaService

import service.User
import runner.Runner
import org.hibernate.query.Query
import aereolinea.Asiento
import Busqueda.Busqueda
import daoImplementacion.HibernateUserDAO
import Excepciones.IlegalQueryException

class BusquedaHibernate implements BusquedaService{
	
	override buscar(Busqueda busqueda, User usuario) {
		
		val session = Runner.getCurrentSession
		
		var hql = "FROM Asiento a" +
		" WHERE " + busqueda.queryFiltro +
		" ORDER BY " + busqueda.queryCriterio + " " + busqueda.queryOrden 
		
		var Query<Asiento> query
		try{
			query = session.createQuery(hql,  Asiento)
		}catch(IllegalArgumentException q){
			throw new IlegalQueryException("Query not fun")
		}
		
		val userDAO = new HibernateUserDAO
		usuario.agregarBusqueda(busqueda)
		
		Runner.runInSession[ {

			userDAO.update(usuario)
			null
		}]
		
		query.getResultList

	}

	override list(User usuario) {
		

		
		val session = Runner.getCurrentSession
		var s = " (select busquedas_id as id from User_Busqueda u where u.User_name = '" + usuario.name + "')"
		
		
		var hql = "from Busqueda b " + 
                 "where b.id in" + s

//		var hql = "select a.id, a.criterio_id, a.orden_id  FROM Busqueda a " + 
//		" leaf join (from User_Busqueda u where User_name = '" + usuario.name + "') b" +
//       				" ON b.busquedas_id = a.id order by a.id desc"
//		
		var Query<Busqueda> query =  session.createQuery(hql, Busqueda)
		query.getResultList

	}
		
	
	
	override busquedasGuardada(Busqueda busqueda, User usuario) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	
	
}