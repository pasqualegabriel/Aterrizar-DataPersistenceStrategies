package perfiles

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class StrategyOfPublication {
	
	protected Publication    		  aNota
	protected ProfileService  		  aService
	
	new(Publication nota, ProfileService service) {
		this.aNota 			= nota
		this.aService     = service
	}
	
	def void execute() 
	
}