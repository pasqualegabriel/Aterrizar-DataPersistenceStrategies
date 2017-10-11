package asientoServicio

import service.User
import java.util.List
import Excepciones.ExepcionCompra
import Excepciones.ExepcionReserva
import runner.Runner
import dao.TramoDAO
import dao.ReservaDAO
import dao.AsientoDAO
import daoImplementacion.HibernateUserDAO
import org.hibernate.query.Query

class ReservaCompraDeAsientos implements AsientoService {

	HibernateUserDAO userDAO
	AsientoDAO 		 asientoDAO
	ReservaDAO 		 reservaDAO
	TramoDAO 		 tramoDAO

	new(HibernateUserDAO unUserDAO, AsientoDAO unAsientoDAO, ReservaDAO unReservaDAO, TramoDAO unTramoDAO) {
		userDAO    = unUserDAO
		asientoDAO = unAsientoDAO
		reservaDAO = unReservaDAO
		tramoDAO   = unTramoDAO
	}

	/**Proposito:Agrega la reserva al usuario y devuelve la misma reserva que fue asignada al usuario  */
	def Reserva agregarReservaAUsuario(User unUsuario, Reserva unaReserva) {
		var reservaUsuario = unUsuario.reserva
		if (reservaUsuario != null) {
			reservaUsuario.invalidar// falta hacer el estado de la reserva
		}
		unUsuario.reserva = unaReserva
		userDAO.update(unUsuario)
		unaReserva
	}

	/**Proposito: verifica que se puede realizar la compra */
	def puedeComprar(Reserva unReserva, User unUsuario) {
		!unReserva.expiroReserva && unUsuario.getPuedeEfectuarLaCompra(unReserva)
	}

	override reservar(Integer asiento, String usuario) {
		Runner.runInSession [
		var unAsiento = asientoDAO.load(asiento)
		var unUsuario = userDAO.loadbyname(usuario)
		
			if (!unAsiento.estaReservado) {
				var unaReserva = new Reserva
				unaReserva.agregarAsiento(unAsiento)
				agregarReservaAUsuario(unUsuario, unaReserva)
			} else {
				throw new ExepcionReserva("No se puede realizar esta reserva por que el asiento ya esta reservado")

			}
		]
	}

	override reservarAsientos(List<Integer> asientos, String usuario) {
		
		Runner.runInSession [
			var unUsuario = userDAO.loadbyname(usuario)
		
			var unosAsientos =asientoDAO.loadAsientos(asientos)
		
			if (unosAsientos.stream.allMatch(asiento|!asiento.estaReservado)) {
				val unaReserva = new Reserva
				unaReserva.asignarleAsientos(unosAsientos)
				agregarReservaAUsuario(unUsuario, unaReserva)
			} else {
				throw new ExepcionReserva("No se puede realizar alguna de las reservas por que el asiento ya esta reservado")
			}
		]	
	}

	override comprar(Integer reserva, String usuario) {
		Runner.runInSession [
			var unUsuario = userDAO.loadbyname(usuario)
			val unReserva = reservaDAO.load(reserva)
			
			if (puedeComprar(unReserva, unUsuario)){
				unUsuario.efectuarCompra(unReserva)
				var tramoDeLaReserva = unReserva.getTramo
				var unaCompra = new Compra(unReserva.asientos, unUsuario, tramoDeLaReserva)
				
				unReserva.eliminarAsientos
				reservaDAO.update(unReserva)
		
				unUsuario.agregarCompra(unaCompra)
				userDAO.update(unUsuario)
				unaCompra
			} else {
				throw new ExepcionCompra("No se pudo efectuar la compra")
			}
		]
	}

	override compras(String userName) {

		Runner.runInSession[
			val session = Runner.getCurrentSession
          
        	var hql = "from Compra c where c.comprador.userName = '" + userName + "'"

			var Query<Compra> query =  session.createQuery(hql, Compra)
			query.getResultList
		]
	}

	override disponibles(Integer tramo) {
		
		var unTramo = tramoDAO.load(tramo)
		
		unTramo.asientosDisponibles
	}


}






