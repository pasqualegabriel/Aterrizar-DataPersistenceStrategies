package perfiles

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.UUID

@Accessors
class Comentary extends Nota{
	
	UUID id
	
	new(){}
	
	new(String aUserProprietor, String unMensaje, Visibilidad unaVisibilidad) {
		super(aUserProprietor,unMensaje,unaVisibilidad)	
	}
	
	override equals(Object aCommentary){
		var commentaryWork = aCommentary as Comentary 
		commentaryWork.id.equals(this.id) && commentaryWork.author.equals(this.author)
	}
	
}
