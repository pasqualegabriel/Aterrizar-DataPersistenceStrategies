package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue

@Accessors
@Entity
class Destino {
	
	@Id
	@GeneratedValue
	int id
	String nombre
	
	new(){
		super()
	}
}