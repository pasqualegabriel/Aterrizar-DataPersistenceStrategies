package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import categorias.Categoria
import asientoServicio.Reserva

@Accessors
class Asiento {
	
	Reserva   reserva
	Tramo	  tramo
	Categoria categoria
	  
	new(Tramo unTramo,Categoria unaCategoria){
		tramo= unTramo
		categoria=unaCategoria
		
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
	
}
