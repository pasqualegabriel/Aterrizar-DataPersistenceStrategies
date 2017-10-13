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
import javax.persistence.CascadeType

@Accessors
@Entity
class Asiento {
	
	@Id
	@GeneratedValue
	public int id
	
	@ManyToOne(cascade=CascadeType.ALL)
	Reserva   reserva
	
	@ManyToOne(cascade=CascadeType.ALL)
	Tramo	  tramo
	
	@ManyToOne(cascade=CascadeType.ALL)
	Categoria categoria
	
	@OneToOne
	User      duenio
	 
	new(){
		super()
	}
	
	new(Tramo unTramo,Categoria unaCategoria){
		tramo     = unTramo
		categoria = unaCategoria
	}
	
	
	/** verifica si el asiento esta reservado o expiro */
	def estaReservado() {
		reserva != null && !reserva.expiroReserva 		
	}
	
	/** Calcula el precio del asiento */
	def calcularPrecio() {
		var precioDelPorcentaje = tramo.precio / 100 * categoria.porcentaje
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
	
	def agregarReserva(Reserva unaReserva) {
		reserva=unaReserva
	}
	
	
	def void eliminarReserva() {
		reserva =null
	}
	
}
