package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.time.LocalTime
import java.time.LocalDateTime
import aereolinea.Asiento
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.OneToMany
import javax.persistence.CascadeType
import javax.persistence.FetchType
import javax.persistence.ManyToOne

@Accessors
@Entity
class Reserva {
	//Estructura
	@Id
	@GeneratedValue
	public int id
	@OneToMany(fetch= FetchType.EAGER, cascade=CascadeType.ALL)
	List<Asiento> asientos	
	
	LocalDateTime horaRealizada	
	@ManyToOne(cascade=CascadeType.ALL)
	EstadoDeReserva estado
	
	new(){
		estado = new Validado
		asientos 		=   newArrayList	
		horaRealizada	= 	LocalDateTime.now
		
	}

	//Proposito: Expresar si la condicion de validacion del asiento expiro. Si lo hizo y el estado era validado
	// Este se cambia para reflejar su nueva condicion
	def expiroReserva() {
		var minutosDespuesDeReservar = Math.abs(LocalTime.now.toSecondOfDay - horaRealizada.toLocalTime.toSecondOfDay) / 60
	    var expiro = minutosDespuesDeReservar >= 5/*minutos de reserva */ 
	    if (expiro)	invalidar
	    
	    !estaValidado
		
	}
	
	def calcularPrecio() {
		asientos.stream.mapToDouble[it.calcularPrecio].sum()
	}
	
	def invalidar(){
		estado = new Expiro
	}
	
	def void asignarleAsientos(List<Asiento> unosAsientos){
		asientos.addAll(unosAsientos)
		unosAsientos.stream.forEach(asiento|asiento.agregarReserva(this))
	}
	
	def agregarAsiento(Asiento unAsiento) {
		asientos.add(unAsiento)
		unAsiento.agregarReserva(this)
	}
	
	def eliminarAsientos() {
		asientos=null
	}
	
	def getTramo() {
		asientos.get(0).tramo
	}
	
	def estaValidado(){
		estado.estaValidado
	}
	
	def comprar() {
		estado = new Comprado
	}
	
	
}