package asientoServicio

import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
class Expiro extends EstadoDeReserva{
	
	new(){}
	
	override estaValidado() {
		false
	}
	
}