package perfiles

import java.util.Set

class AccesoAComentarioStrategy extends StrategyOfNote{
	
	Publication aPublication
	Comentary   aComentary
	
	new(Publication publication, Comentary comentary) {
		this.aPublication = publication
		this.aComentary   = comentary
	}
	
	override execute() {
			aPublication.comentarios.add(aComentary)
	}
	
	override addAndRemove(Set<String> colleccionAAgregar, Set<String> colleccionAQuitar, String aUserId) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override void negateAccess(){
	
	}
	
}