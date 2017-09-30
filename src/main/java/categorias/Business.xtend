package categorias

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity

@Entity
@Accessors
class Business extends Categoria{

	new(){
		super()
		nombre = "Business"
	}
	
	override porcentaje() {
		
		25.00
	}
	
}