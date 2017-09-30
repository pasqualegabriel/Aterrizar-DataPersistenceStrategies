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
import javax.persistence.GeneratedValue
import javax.persistence.Column

@Accessors
@Entity
class Reserva {
	//Estructura
	@Id @GeneratedValue
	@Column(name = "reserva_id")
	int id
	@Transient
	List<Asiento> asientos 		
	
	LocalDateTime horaRealizada	
	boolean	      estaValidado	
	
	new(){
		
		id=0 
		asientos 		= 	newArrayList
		estaValidado	=	true
		asientos 		=	null
		horaRealizada	= 	LocalDateTime.now
		
	}
	
	
	new(User unUsuario){
		this()
		
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