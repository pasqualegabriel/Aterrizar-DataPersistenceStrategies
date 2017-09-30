package Busqueda
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Accessors
@Entity
class Descendente extends Orden{
		
	new(){
		super()
	}
	
	override getOrden() {
		"DESC"
	}
}