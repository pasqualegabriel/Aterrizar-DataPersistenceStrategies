package Busqueda

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id

@Accessors
@Entity
class Busqueda {
	
	@Id
	int id
	
	Filtro   unFiltro
	Criterio unCriterio
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