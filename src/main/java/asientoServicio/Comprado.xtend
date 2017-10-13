package asientoServicio

import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
class Comprado extends EstadoDeReserva{
	
	new(){}
	
	override estaValidado() {
		false
	}
	
}