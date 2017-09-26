package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.time.LocalTime
import java.time.LocalDateTime
import aereolinea.Asiento

@Accessors
class Reserva {
	//Estructura
	List<Asiento> asientos 		= newArrayList
	LocalDateTime horaRealizada	= LocalDateTime.now
	boolean	      estaValidado	= true 

	
	def expiroReserva() {
		var minutosDespuesDeReservar = Math.abs(LocalTime.now.toSecondOfDay - horaRealizada.toLocalTime.toSecondOfDay) / 60
	    minutosDespuesDeReservar >= 5/*minutos de reserva */ || !estaValidado
		
	}
	
	def calcularPrecio() {
		asientos.stream.mapToDouble[it.calcularPrecio].sum()
	}
	
	def invalidar(){
		estaValidado = false
	}
	
}