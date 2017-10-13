package asientoServicio

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue

@Accessors
@Entity
abstract class EstadoDeReserva {
	
	@Id
	@GeneratedValue
	int id
	
	def Boolean estaValidado()
}