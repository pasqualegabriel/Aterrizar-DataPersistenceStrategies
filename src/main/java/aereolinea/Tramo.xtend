package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List

@Accessors
class Tramo {
	List<Asiento> asientos = newArrayList
	Destino destinoOrigen
	Destino destinoLlegada
	Date fechaDeLlegada
	Date fechaDeSalida
	Double precio
	
	new(){
		super()
	}
	
	new(Double unPrecioBase){
		precio=unPrecioBase
	}
	
	def asientosDisponibles() {
		
		asientos.filter[it.estaDisponible].toList
	}
	
}
