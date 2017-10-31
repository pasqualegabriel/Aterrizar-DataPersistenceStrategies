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
import aereolinea.Asiento
import Excepciones.ExepcionDatosInexistentes
import dao.CompraDAO

class ReservaCompraDeAsientos implements AsientoService {

	HibernateUserDAO userDAO
	AsientoDAO 		 asientoDAO
	ReservaDAO 		 reservaDAO
	TramoDAO 		 tramoDAO
	CompraDAO        compraDAO

	new(HibernateUserDAO unUserDAO, AsientoDAO unAsientoDAO, ReservaDAO unReservaDAO, TramoDAO unTramoDAO, CompraDAO unaCompraDAO) {
		
		userDAO    = unUserDAO
		asientoDAO = unAsientoDAO
		reservaDAO = unReservaDAO
		tramoDAO   = unTramoDAO
		compraDAO  = unaCompraDAO
	}

	/**Proposito:Agrega la reserva al usuario y devuelve la misma reserva que fue asignada al usuario  */
	def Reserva agregarReservaAUsuario(User unUsuario, Reserva unaReserva) {
		var reservaUsuario = unUsuario.reserva
		//Si el usuario tenia una reserva antes, va a tener que invalidarla, y pisarla
		if (reservaUsuario != null) {
			reservaUsuario.invalidar
			reservaDAO.update(reservaUsuario)
		}
		unUsuario.reserva = unaReserva
		userDAO.update(unUsuario)
		unaReserva
	}

	/**Proposito: verifica que se puede realizar la compra */
	def puedeComprar(Reserva unReserva, User unUsuario) {
		var resultado = !unReserva.expiroReserva && unUsuario.puedeEfectuarLaCompra(unReserva) && (unUsuario.reserva == unReserva)
		//Si la reserva estaba en estado validado, y expiro, va a cambiar su estado, hay que persistir ese cambio
		reservaDAO.update(unReserva)
		resultado
	}

	override reservar(Integer asiento, String usuario) {
		
		reservarAsientos(#[asiento], usuario)
	}
	
	override reservarAsientos(List<Integer> asientos, String usuario) {
		
		Runner.runInSession [
			
			//Se va a buscar al usuario y a los asientos
			
			var unUsuario    = userDAO.loadbyname(usuario)
			var unosAsientos = asientoDAO.loadAsientos(asientos)
			
			//Si no encuentra alguno, se levanta la excepcion
			if(algunAsientoEsNull(unosAsientos) ||  isUserNull(unUsuario)){
				throw new ExepcionDatosInexistentes("No se puede llevar acabo la reserva el usuario o asiento no existen")
			} 
			
			//Si ninguno de los asientos esta reservado, efectuo las reservas.
			if (unosAsientos.stream.allMatch[ estaDisponible(it)] ){
				val unaReserva = new Reserva
				unaReserva.asignarleAsientos(unosAsientos)
				agregarReservaAUsuario(unUsuario, unaReserva)
			} else {
				//Alguno de los asientos esta reservado, por lo que no se puede efectuar la reserva
				throw new ExepcionReserva("No se puede realizar alguna de las reservas por que el asiento esta comprado o reservado")
			}
		]	
	}
	
	def algunAsientoEsNull(List<Asiento> asientos) {
		asientos.stream.anyMatch[ it == null ]
	}
	
	def estaDisponible(Asiento unAsiento) {
		// Preguntamos si el asiento no esta comprado ni reservado. 
		// Si la reserva estaba validada, y expiro va a cambiar de estado
		// Por lo que hay que updatear ese cambio
		// Puede que el asiento no este reservado por que directamente no tiene reserva, 
		// por eso se pregunta por null
		var resultado = unAsiento.estaDisponible
		if(unAsiento.reserva != null){ 
			reservaDAO.update(unAsiento.reserva)
		}
		resultado
	}

	override comprar(Integer reserva, String usuario) {
		
		Runner.runInSession [
			//Se van a buscar al usuario y a su reserva
			var unUsuario = userDAO.loadbyname(usuario)
			val unReserva = reservaDAO.load(reserva)
			
			//Si no encuentra alguno de los datos, se levanta una excepcion
			if(unReserva==null || isUserNull(unUsuario)){
				throw new ExepcionDatosInexistentes("No se puede llevar acabo la compra, el usuario o la reserva no existen")	
			}
			
			

			if(puedeComprar(unReserva, unUsuario)){
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
	
	def isUserNull(User user) {
		user == null
	}

	override compras(String userName) {

		Runner.runInSession[
			
			compraDAO.compras(userName)
		]
	}

	override disponibles(Integer tramo) {
		
		Runner.runInSession[
			val unTramo = tramoDAO.load(tramo)
			if(unTramo==null){
				throw new ExepcionDatosInexistentes("No existe el tramo")
			}
			unTramo.asientosDisponibles	
		]
	}


}






