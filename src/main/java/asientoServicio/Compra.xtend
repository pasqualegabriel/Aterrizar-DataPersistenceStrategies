package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import aereolinea.Asiento
import service.User
import javax.persistence.Entity
import javax.persistence.Transient
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.GeneratedValue

@Accessors
@Entity
class Compra {
	@Id
	@GeneratedValue
	int id
	
	@ManyToOne
	User comprador
	
	@Transient
	List<Asiento> asientos
	
	new(){
		super()

	}
	
	new(List<Asiento> unosAsientos, User unUsuario) {
		this()
		comprador=unUsuario
		asientos=unosAsientos
		asientos.forEach[it.agregarDuenio(unUsuario)]
	}
	
}