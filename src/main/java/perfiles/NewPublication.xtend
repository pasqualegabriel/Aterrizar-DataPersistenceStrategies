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
	
	def Publication canPublish(Publication aPublication, ProfileService service) {
		
		val sePublico = service.sePublico(aPublication)
		val seVisito = service.visitoDestino(aPublication)
		
		publicationPermissions.findFirst[it.canHandle(sePublico, seVisito)].execute(aPublication, service)
	}
	
}