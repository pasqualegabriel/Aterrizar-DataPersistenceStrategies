package categorias

import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
abstract class Categoria {
	
	@Id
	@GeneratedValue
	@Column(name="id")
	int id
	
	def abstract Double porcentaje()
}