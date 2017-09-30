package Busqueda
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Accessors
@Entity
class Ascendente extends Orden{
		
	new(){
		super()
	}
	
	override getOrden() {
		"ASC"
	}
	
}