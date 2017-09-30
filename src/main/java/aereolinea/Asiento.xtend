package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import categorias.Categoria
import asientoServicio.Reserva
import service.User
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import javax.persistence.ManyToOne
import javax.persistence.Entity
import javax.persistence.OneToOne
import javax.persistence.JoinTable

@Accessors
@Entity
class Asiento {
	
	@Id
	@GeneratedValue
	@Column(name="id")
	int id
	@ManyToOne
	Reserva   reserva
	
	@ManyToOne
	Tramo	  tramo
	
	@ManyToOne
	@JoinTable(name="id")
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
	
}
