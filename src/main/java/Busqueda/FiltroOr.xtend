package Busqueda
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Accessors
@Entity
class FiltroOr extends FiltroCompuesto {
		
	new(){
		super()
	}
	
	new(Filtro aFilterOne, Filtro aFilterTwo) {
		super(aFilterOne, aFilterTwo)
	}
	
	override comparator() {
		" or "
	}
	
	override getFiltro() {
		super.filtro
	}
	
}