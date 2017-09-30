package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List
import javax.persistence.OneToMany
import javax.persistence.ManyToOne
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Transient

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
	@Transient
	Vuelo vuelo
	
	new(){
		super()
	}
	
	new(Double unPrecioBase, Vuelo unVuelo){
		precio=unPrecioBase
		vuelo = unVuelo
	}
	
	def asientosDisponibles() {
		
		asientos.filter[it.estaDisponible].toList
	}
	
}
