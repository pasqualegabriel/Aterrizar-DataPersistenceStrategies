package Busqueda

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.OneToOne
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.CascadeType
import javax.persistence.GeneratedValue

@Accessors
@Entity
class Busqueda {
	
	@Id
	@GeneratedValue
	int      id
	
	@OneToOne
	@JoinColumn(name="id")
	Filtro   filtro
	
	@ManyToOne(cascade=CascadeType.ALL)
	Criterio criterio
	
	@ManyToOne(cascade=CascadeType.ALL)
	Orden    orden
	
	new(){
		super()
	}
	
	new(Filtro unFiltro, Criterio unCriterio, Orden unOrden){
		this()
		filtro   	= unFiltro
		criterio 	= unCriterio
	    orden    	= unOrden
	}
	
	def queryFiltro() {
		filtro.filtro
	}
	
	def queryCriterio() {
		criterio.criterio
	}
	
	def queryOrden() {
		orden.orden
	}
	
}