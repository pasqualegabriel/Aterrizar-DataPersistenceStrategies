package categorias

import javax.persistence.Id
import javax.persistence.GeneratedValue

import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
abstract class Categoria {
	
	@Id
	@GeneratedValue
	int id
	
	String nombre
	
	def abstract Double porcentaje()
	
	def String nombreCategoria(){
		nombre
	}
	
}