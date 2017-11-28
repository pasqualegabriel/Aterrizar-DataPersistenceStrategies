package perfiles

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class NewPublication {
	
	List<CanPublish> publicationPermissions
	
	new(){
		super()
		publicationPermissions = #[new YaPublico, new NoVisitoDestino, new PuedePublicar]
	}
	
	def canPublish(Publication aPublication, ProfileService service) {
		
		publicationPermissions.findFirst[it.canHandle(aPublication, service)].execute(aPublication, service)
	}
	
}