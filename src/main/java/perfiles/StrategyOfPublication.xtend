package perfiles

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class StrategyOfPublication extends PublicationOfNote{
	
	
	
	new( ProfileService service) {
		
		this.profileService = service
	}
	
	
	
	
}




