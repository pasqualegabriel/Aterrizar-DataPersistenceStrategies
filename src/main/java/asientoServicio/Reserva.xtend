package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.time.LocalTime
import java.time.LocalDateTime
import aereolinea.Asiento
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import javax.persistence.OneToMany
import javax.persistence.CascadeType


@Accessors
@Entity
class Reserva {
	//Estructura
	@Id
	@GeneratedValue
	@Column(name="id")
	int id
	@OneToMany(mappedBy="reserva", cascade=CascadeType.ALL)
	List<Asiento> asientos	
	
	LocalDateTime horaRealizada	
	boolean	      estaValidado
	
	
	new(){
		asientos = newArrayList	
		estaValidado	=	true
		horaRealizada	= 	LocalDateTime.now
		
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
	def void asignarleAsientos(List<Asiento> unosAsientos){
		asientos.addAll(unosAsientos)
	}
	
	
}