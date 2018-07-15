package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import javax.persistence.OneToMany
import javax.persistence.ManyToOne
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.CascadeType
import java.time.LocalDateTime
import javax.persistence.FetchType

@Accessors
@Entity
class Tramo {
	@Id
	@GeneratedValue
	public int		  id
	 
	@OneToMany(fetch= FetchType.LAZY,mappedBy="tramo")
	List<Asiento> asientos = newArrayList
	
	@ManyToOne(fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	Destino   destinoOrigen
	
	@ManyToOne(fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	Destino   destinoLlegada
	
	 
	LocalDateTime	  fechaDeLlegada
	LocalDateTime 	  fechaDeSalida
	Double 	  precio
	
	@ManyToOne(cascade=CascadeType.ALL)
	Vuelo     vuelo
	
	int       duracion
	
	new(){
		super()
	}
	
	new(Double unPrecioBase, Vuelo unVuelo, Destino unDestinoOrigen, Destino unDestinoLlegada, LocalDateTime unaFechaDeSalida, LocalDateTime unaFechaDeLlegada){
		this()
		precio         = unPrecioBase
		vuelo          = unVuelo
		destinoOrigen  = unDestinoOrigen
		destinoLlegada = unDestinoLlegada
		fechaDeSalida  = unaFechaDeSalida
		fechaDeLlegada = unaFechaDeLlegada
		duracion 	   = Math.abs(fechaDeLlegada.toLocalTime.toSecondOfDay - fechaDeSalida.toLocalTime.toSecondOfDay) / 60
	
	}
	
	def asientosDisponibles() {
		
		asientos.filter[it.estaDisponible].toList
	}

	
}
