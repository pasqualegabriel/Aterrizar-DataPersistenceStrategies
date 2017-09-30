package Busqueda
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Accessors
@Entity
class FiltroAnd extends FiltroCompuesto {
		
	new(){
		super()
	}
	
	new(Filtro aFilterOne, Filtro aFilterTwo) {
		super(aFilterOne, aFilterTwo)
	}
	
	override comparator() {
		" and "
	}
	
	override getFiltro() {
		super.filtro
	}
	
	
	
}