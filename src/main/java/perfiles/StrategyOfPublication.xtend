package perfiles

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class StrategyOfPublication {
	
	protected Publication    aPublication
	protected ProfileService  aService
	
	new(Publication publication, ProfileService service) {
		this.aPublication = publication
		this.aService     = service
	}
	
	def void execute() 
	
}