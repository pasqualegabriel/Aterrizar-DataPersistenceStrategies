package perfiles

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class StrategyOfPublication extends StrategyOfNote{
	
	protected Publication    aNota
	protected ProfileService aService
	
	new( ProfileService service) {
		
		this.aService = service
	}
	
	override void execute() 
	
	
}




