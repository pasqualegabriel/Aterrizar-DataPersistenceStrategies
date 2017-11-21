package perfiles

import java.util.Set
import service.User

class AccesoAPublicacionStrategy extends StrategyOfNote {
	
	Profile 		profile
	Publication		publication
	
	new(Profile aProfile,Publication aPublication) {
		this.profile      = aProfile
		this.publication  = aPublication 
	}
	
	override execute() {
		profile.publications.add(publication)
	}
	
	//Esto no se necesita, crear una mejor abstraccion para STrategyOfNote
	override addAndRemove(Set<String> colleccionAAgregar, Set<String> colleccionAQuitar, String aUserId) {
		
	}
	
	//Esto no se necesita, crear una mejor abstraccion para STrategyOfNote
	override def void negateAccess(){
		
	}
	
}