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
import aereolinea.Asiento
import Excepciones.ExepcionDatosInexistentes

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
			//unaReserva.estadoReservada estado = EstadoDeReserva.Reservada
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
			if(unAsiento == null || isUserNull(unUsuario)){
				throw new ExepcionDatosInexistentes("No se puede llevar acabo la reserva el usuario o asiento no existen")
			}
			
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
			var unUsuario    = userDAO.loadbyname(usuario)
			var unosAsientos = asientoDAO.loadAsientos(asientos)
			if(algunAsientoEsNull(unosAsientos) ||  isUserNull(unUsuario)){
				throw new ExepcionDatosInexistentes("No se puede llevar acabo la reserva el usuario o asiento no existen")
			} 
			
			if (unosAsientos.stream.allMatch( asiento | !asiento.estaReservado)) {
				val unaReserva = new Reserva
				unaReserva.asignarleAsientos(unosAsientos)
				agregarReservaAUsuario(unUsuario, unaReserva)
			} else {
				throw new ExepcionReserva("No se puede realizar alguna de las reservas por que el asiento ya esta reservado")
			}
		]	
	}
	
	def algunAsientoEsNull(List<Asiento> asientos) {
		asientos.stream.anyMatch[ it == null ]
	}

	override comprar(Integer reserva, String usuario) {
		
		Runner.runInSession [
			var unUsuario = userDAO.loadbyname(usuario)
			val unReserva = reservaDAO.load(reserva)
			if(unReserva==null || isUserNull(unUsuario)){
				throw new ExepcionDatosInexistentes("No se puede llevar acabo la compra, el usuario o la reserva no existen")	
			}
			if (puedeComprar(unReserva, unUsuario)){
				unUsuario.efectuarCompra(unReserva)
				var tramoDeLaReserva = unReserva.getTramo
				var unaCompra = new Compra(unReserva.asientos, unUsuario, tramoDeLaReserva)
				
				unReserva.eliminarAsientos
				//unaReserva.estadoComprada estado = EstadoDeReserva.Comprada
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
			val session = Runner.getCurrentSession
          
        	var hql = "from Compra c where c.comprador.userName = '" + userName + "'"

			var Query<Compra> query =  session.createQuery(hql, Compra)
			query.getResultList
		]
	}

	override disponibles(Integer tramo) {
		
		Runner.runInSession[
			val unTramo = tramoDAO.load(tramo)
			if(unTramo==null){
				throw new ExepcionDatosInexistentes("No existe el tramo")
			}//testear
			unTramo.asientosDisponibles	
		]
	}


}






