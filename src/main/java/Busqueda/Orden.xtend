package Busqueda
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue

@Accessors
@Entity
abstract class Orden {
	
	@Id
    @GeneratedValue
	int id
	
	def abstract String getOrden()
	
}