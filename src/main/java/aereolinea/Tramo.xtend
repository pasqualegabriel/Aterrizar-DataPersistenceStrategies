package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date

@Accessors
class Tramo {
	Destino destinoOrigen
	Destino destinoLlegada
	Date fechaDeLlegada
	Date fechaDeSalida
	Double precio
	
	new(Double unPrecioBase){
		precio=unPrecioBase
	}	
}
