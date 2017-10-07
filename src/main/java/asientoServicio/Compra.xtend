package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import aereolinea.Asiento
import service.User
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.GeneratedValue
import javax.persistence.OneToMany

import javax.persistence.FetchType

import javax.persistence.CascadeType
import aereolinea.Tramo

@Accessors
@Entity
class Compra {
	@Id
	@GeneratedValue
	int id
	
	@ManyToOne(cascade=CascadeType.ALL)
	User comprador

	@OneToMany(fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	List<Asiento> asientos
	
	@ManyToOne(cascade=CascadeType.ALL)
	Tramo tramo
	
	new(){
		super()

	}
	
	new(List<Asiento> unosAsientos, User unUsuario, Tramo unTramo) {
		this()
		comprador=unUsuario
		asientos=unosAsientos
		tramo= unTramo
		agregarDuenios(unUsuario)
		
	}
	
	def void agregarDuenios(User unUsuario) {
		asientos.forEach[it.agregarDuenio(unUsuario)]
		asientos.forEach[it.eliminarReserva]
	}
	
}