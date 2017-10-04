package asientoServicio

import service.User
import java.util.List
import Excepciones.ExepcionCompra
import Excepciones.ExepcionReserva
import aereolinea.Asiento
import aereolinea.Tramo
import dao.UserDAO
import runner.Runner

class ReservaCompraDeAsientos implements AsientoService {

	UserDAO userDAO

	new(UserDAO unUserDAO) {
		userDAO = unUserDAO
	}

	def updateUser(User aUser) {
		Runner.runInSession [{
				userDAO.update(aUser)
				null
			}]
	}
	
	/**Proposito:Agrega la reserva al usuario y devuelve la misma reserva que fue asignada al usuario  */
	def Reserva agregarReservaAUsuario(User unUsuario, Reserva unaReserva) {
		var reservaUsuario = unUsuario.reserva
		if (reservaUsuario != null) {
			reservaUsuario.invalidar
		/** O persistir la columna o borrar de la tabal el objeto*/ 
		}
		unUsuario.reserva = unaReserva
		updateUser(unUsuario)
		unaReserva
	}
	
	/**Proposito: verifica que se puede realizar la compra */
	def puedeComprar(Reserva unReserva, User unUsuario) {
		!unReserva.expiroReserva && unUsuario.getPuedeEfectuarLaCompra(unReserva)
	}
	


	override reservar(Asiento unAsiento, User unUsuario) {

		if (!unAsiento.estaReservado) {
			var unaReserva = new Reserva
			unaReserva.agregarAsiento(unAsiento)
			agregarReservaAUsuario(unUsuario, unaReserva)
		} else {
			throw new ExepcionReserva("No se puede realizar esta reserva por que el asiento ya esta reservado")

		}
	}


	override reservarAsientos(List<Asiento> unosAsientos, User unUsuario) {

		if (unosAsientos.stream.allMatch(asiento|!asiento.estaReservado)) {
			val unaReserva = new Reserva
			unaReserva.asignarleAsientos(unosAsientos)
			agregarReservaAUsuario(unUsuario, unaReserva)
		} else {
			throw new ExepcionReserva(
				"No se puede realizar alguna de las reservas por que el asiento ya esta reservado")
		}
	}
	
	

	override comprar(Reserva unReserva, User unUsuario) {
		if (puedeComprar(unReserva, unUsuario)) {
			unUsuario.efectuarCompra(unReserva)
			var unaCompra = new Compra(unReserva.asientos, unUsuario)
			unUsuario.agregarCompra(unaCompra)
			Runner.runInSession [{
				unReserva.eliminarAsientos
				Runner.currentSession.update(unReserva)
				null
			}]
			updateUser(unUsuario)
			unaCompra
		}else {
			throw new ExepcionCompra("No se pudo efectuar la compra")
		}
	}



	override compras(User usuario) {
		usuario.compras
	}

	override disponibles(Tramo unTramo) {
		unTramo.asientosDisponibles
	}

}
