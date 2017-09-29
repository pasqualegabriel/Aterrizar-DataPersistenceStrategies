package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.time.LocalTime
import java.time.LocalDateTime
import aereolinea.Asiento
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Transient
import service.User
import javax.persistence.OneToOne

@Accessors
@Entity
class Reserva {
	//Estructura
	@Id
	int id
	@Transient
	List<Asiento> asientos 		
	
	LocalDateTime horaRealizada	
	boolean	      estaValidado	
	@OneToOne 
	User usuario
	
	new(){
		
		id=0 
		asientos 		= 	newArrayList
		estaValidado	=	true
		asientos 		=	null
		horaRealizada	= 	LocalDateTime.now
		
	}
	
	
	new(User unUsuario){
		this()
		usuario = unUsuario
		
	}
	
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