package categorias

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Turista extends Categoria {

	new(){
		super()
		nombre = "Turista"
	}
	
	override porcentaje() {
		10.00
	}
	

}