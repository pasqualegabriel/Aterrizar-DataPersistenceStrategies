package perfiles

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.UUID

@Accessors
class Comentary extends asdasdasd{
	
	UUID id
	
	new(){}
	
	new(String aUserProprietor, String unMensaje, Visibilidad unaVisibilidad) {
		super(aUserProprietor,unMensaje,unaVisibilidad)	
		this.id = UUID.randomUUID
	}
	
}
