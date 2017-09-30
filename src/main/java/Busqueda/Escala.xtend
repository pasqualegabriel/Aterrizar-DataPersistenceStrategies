package Busqueda
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Accessors
@Entity
class Escala extends Criterio{
		
	new(){
		super()
	}
	
	override getCriterio() {
		"a.tramo"
	}
}