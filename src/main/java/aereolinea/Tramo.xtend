package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List
import javax.persistence.OneToMany
import javax.persistence.ManyToOne
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue

@Accessors
@Entity
class Tramo {
	@Id
	@GeneratedValue
	int id
	 
	@OneToMany
	List<Asiento> asientos = newArrayList
	@ManyToOne
	Destino destinoOrigen
	@ManyToOne
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
