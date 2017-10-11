package Busqueda

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.OneToOne
import javax.persistence.ManyToOne
import javax.persistence.CascadeType
import javax.persistence.GeneratedValue
import service.User
import javax.persistence.FetchType

@Accessors
@Entity
class Busqueda {
	
	@Id
	@GeneratedValue
	public int id
	
	@OneToOne(fetch= FetchType.EAGER, cascade=CascadeType.ALL)
	Filtro     filtro
	
	@ManyToOne(fetch= FetchType.EAGER,cascade=CascadeType.ALL)
	Criterio   criterio
	
	@ManyToOne(fetch= FetchType.EAGER,cascade=CascadeType.ALL)
	Orden      orden
	
	@ManyToOne(fetch= FetchType.EAGER, cascade=CascadeType.ALL)
	User       user
	
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
	def void setUsuario(User unUser){
		user=unUser
	}
	
	
	def queryOrden() {
	
		orden.orden
	}
	
}