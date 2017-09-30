package categorias

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Entity
@Accessors
class Primera extends Categoria {
	
	new(){
		super()
		nombre = "Primera"
	}
	
	override porcentaje() {
		40.00
	}
	
}