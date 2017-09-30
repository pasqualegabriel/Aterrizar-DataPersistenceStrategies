package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import categorias.Categoria
import asientoServicio.Reserva
import service.User

@Accessors
class Asiento {
	
	Reserva   reserva
	Tramo	  tramo
	Categoria categoria
	User      duenio
	  
	new(Tramo unTramo,Categoria unaCategoria){
		tramo= unTramo
		categoria=unaCategoria
		
	}
	
	def getPrecio(){
		tramo.precio + categoria.porcentaje * tramo.precio
	}
	
	/** verifica si el asiento esta reservado o expiro */
	def estaReservado() {
		reserva != null && !reserva.expiroReserva 
				
	}
	
	/** Calcula el precio del asiento */
	def calcularPrecio() {
		var precioDelPorcentaje= tramo.precio / 100 * categoria.porcentaje
		tramo.precio + precioDelPorcentaje
	}
	
	def estaDisponible() {
		!estaReservado && duenio == null
	}
	
	def agregarDuenio(User comprador) {
		duenio = comprador
	}
	
}
