package perfiles

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

// Responsabilidad: Se hace cargo de proveer el estado adecuado para la nueva publicacion

@Accessors
class NewPublication {
	
	List<StateOfTheNewPublication> publicationPermissions
	
	new(){
		super()
		publicationPermissions = #[new YaPublico, new NoVisitoDestino, new PuedePublicar]
	}
	
	def canPublish(Publication aPublication, ProfileService service) {
		
		publicationPermissions.findFirst[it.canHandle(aPublication, service)].execute(aPublication, service)
	}
	
}