package categorias

import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
class Business extends Categoria{
	
	new(){
		super()
		
	}
	
	override porcentaje() {
		
		25.00
	}
	
}