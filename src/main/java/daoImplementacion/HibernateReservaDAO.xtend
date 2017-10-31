package daoImplementacion

import dao.ReservaDAO
import asientoServicio.Reserva
import runner.Runner

class HibernateReservaDAO implements ReservaDAO {

	override save(Reserva unaReserva) {
		val session = Runner.currentSession
		session.save(unaReserva)
	}

	override load(Integer unaReserva) {
		var session = Runner.currentSession
		session.get(Reserva, unaReserva)
	}

	override update(Reserva unaReserva) {
		val session = Runner.getCurrentSession
		session.update(unaReserva)
	}

}
