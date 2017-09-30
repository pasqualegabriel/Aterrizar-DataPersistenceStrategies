package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import categorias.Categoria
import asientoServicio.Reserva
import service.User
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.ManyToOne
import javax.persistence.Entity
import javax.persistence.OneToOne
import javax.persistence.JoinTable
import javax.persistence.CascadeType
import javax.persistence.FetchType

@Accessors
@Entity
class Asiento {
	
	@Id
	@GeneratedValue
	int id
	@ManyToOne(fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	Reserva   reserva
	
	@ManyToOne(fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	Tramo	  tramo
	
	@ManyToOne (fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	Categoria categoria
	
	@OneToOne
	@JoinTable(name="name")
	User      duenio
	
	 
	new(){
		super()
	}
	
	new(Tramo unTramo,Categoria unaCategoria){
		tramo= unTramo
		categoria=unaCategoria
	
		
	}
	
	def getPrecio(){
		tramo.precio + categoria.porcentaje * tramo.precio
	}
	
	/** verifica si el asiento esta reservado o expiro */
	def estaReservado() {
		reserva != null && !reserva.expiroReserva 		
	}
	
	/** Calcula el precio del asiento */
	def calcularPrecio() {
		var precioDelPorcentaje= tramo.precio / 100 * categoria.porcentaje
		tramo.precio + precioDelPorcentaje
	}
	
	def estaDisponible() {
		!estaReservado && duenio == null
	}
	
	def agregarDuenio(User comprador) {
		duenio = comprador
	}
	
	
	def String nombreCategoria() {
		categoria.nombreCategoria
	}
	
}
