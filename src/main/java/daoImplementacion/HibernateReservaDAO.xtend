package daoImplementacion

import dao.ReservaDAO
import runner.Runner
import asientoServicio.Reserva
import org.hibernate.Session
import runner.SessionFactoryProvider

class HibernateReservaDAO implements ReservaDAO {

	override save(Reserva aReservation) {
		val Session session = Runner.currentSession
		session.save(aReservation)
	
	}

	override load(Reserva aReservation) {
		var session = Runner.currentSession
		session.get(Reserva, aReservation.id)
	}

	override update(Reserva aReservation) {
		val session = Runner.getCurrentSession
		session.update(aReservation)

	}

	override clearAll() {
		SessionFactoryProvider.destroy
	}



}