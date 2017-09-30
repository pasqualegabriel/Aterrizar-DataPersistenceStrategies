package Busqueda
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Accessors
@Entity
class CampoDestino extends Campo{
	
	new(){
		super()
	}
	
	override getCampo() {
		"a.tramo.destinoLlegada.nombre"
	}
}