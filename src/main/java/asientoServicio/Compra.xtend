package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import aereolinea.Asiento
import service.User
import javax.persistence.Entity
import javax.persistence.Transient
import javax.persistence.Id
import javax.persistence.ManyToOne

@Accessors
@Entity
class Compra {
	@Id
	int id
	
	@ManyToOne
	User comprador
	
	@Transient
	List<Asiento> asientos
	
	new(){
		super()
		id = 1
		
	}
	
	new(List<Asiento> unosAsientos, User unUsuario) {
		this()
		comprador=unUsuario
		asientos=unosAsientos
		asientos.forEach[it.agregarDuenio(unUsuario)]
	}
	
}