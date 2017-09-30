package asientoServicio

import service.User
import java.util.List
import Excepciones.ExepcionCompra
import Excepciones.ExepcionReserva
import aereolinea.Asiento
import aereolinea.Tramo
import dao.UserDAO

class ReservaCompraDeAsientos implements AsientoService{
	
	UserDAO userDAO
	
	new(UserDAO unUserDAO){
		userDAO=unUserDAO
	}
	
	override reservar(Asiento unAsiento, User unUsuario) {
		
		if(!unAsiento.estaReservado){
			var unaReserva = new Reserva
			unaReserva.asientos.add(unAsiento)	
			unAsiento.reserva = unaReserva
			agregarReservaAUsuario(unUsuario,unaReserva)
			unaReserva
		}else{
			throw new ExepcionReserva("No se puede realizar esta reserva por que el asiento ya esta reservado")
			
		}
	}
	
	def agregarReservaAUsuario(User unUsuario, Reserva unaReserva) {
		var reservaUsuario= unUsuario.reserva
		if(reservaUsuario != null){
			reservaUsuario.estaValidado = false	
		}
		unUsuario.reserva=unaReserva
	}
	
	override reservarAsientos(List<Asiento> unosAsientos, User unUsuario) {
		
		if (unosAsientos.stream.allMatch(asiento|!asiento.estaReservado)){
			val unaReserva = new Reserva
			unaReserva.asientos = unosAsientos
			unosAsientos.stream.forEach(asiento | asiento.reserva =unaReserva)
			agregarReservaAUsuario(unUsuario,unaReserva)
			unaReserva
		}else{
			throw new ExepcionReserva("No se puede realizar alguna de las reservas por que el asiento ya esta reservado")
			
		}
	}
		
	override comprar(Reserva unReserva, User unUsuario) {
		if(puedeComprar(unReserva,unUsuario)){
			
			unUsuario.monedero = unUsuario.monedero - unReserva.calcularPrecio
			var unaCompra = new Compra(unReserva.asientos, unUsuario)
			unUsuario.agregarCompra(unaCompra)
			userDAO.update(unUsuario)
			unaCompra
		}else{
			throw new ExepcionCompra("No se pudo efectuar la compra")
		}	
	}
	
	def puedeComprar(Reserva unReserva, User unUsuario){
		 !unReserva.expiroReserva && unUsuario.monedero>=unReserva.calcularPrecio
	}
	
	

	/** Preguntar si hay q testiar un getter aca si es q es un geter  */
	override compras(User usuario) {
		usuario.compras
	}
	
	override disponibles(Tramo unTramo) {
		unTramo.asientosDisponibles
	}
	
	

}