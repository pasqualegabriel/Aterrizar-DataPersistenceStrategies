package daoImplementacion

import dao.CompraDAO
import runner.Runner
import asientoServicio.Compra
import org.hibernate.query.Query

class HibernateCompraDAO implements CompraDAO{
	
	override compras(String userName) {
		
		val session = Runner.getCurrentSession
          
    	var hql = "from Compra c where c.comprador.userName = '" + userName + "'"

		var Query<Compra> query =  session.createQuery(hql, Compra)
		query.getResultList
		
	}
	
}
