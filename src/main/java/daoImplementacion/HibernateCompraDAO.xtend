package daoImplementacion

import dao.CompraDAO

import org.hibernate.Session
import runner.Runner
import runner.SessionFactoryProvider
import asientoServicio.Compra

class HibernateCompraDAO implements CompraDAO {
	
	override save(Compra aPurchase) {
		val Session session = Runner.currentSession
		session.save(aPurchase)
	}
	
	override load(Compra aPurchase) {
		var session = Runner.currentSession
		session.get(Compra,aPurchase.id)
	}
	
	override update(Compra aPurchase) {
		val session = Runner.getCurrentSession
		session.update(aPurchase)
	}
	
	override clearAll() {
		SessionFactoryProvider.destroy
	}
	


	
	
}