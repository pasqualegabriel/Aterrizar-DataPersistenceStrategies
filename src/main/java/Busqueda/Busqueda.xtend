package Busqueda

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.OneToOne
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Accessors
@Entity
class Busqueda {
	
	@Id
	int      id
	
	@OneToOne
	@JoinColumn(name="id")
	Filtro   unFiltro
	
	@ManyToOne
	Criterio unCriterio
	
	@ManyToOne
	Orden    unOrden
	
	new(){
		super()
	}
	
	new(Filtro filtro, Criterio criterio, Orden orden){
		this()
		unFiltro   = filtro
		unCriterio = criterio
	    unOrden    = orden
	}
	
	def getFiltro() {
		unFiltro.filtro
	}
	
	def getCriterio() {
		unCriterio.criterio
	}
	
	def orden() {
		unOrden.orden
	}
	
}