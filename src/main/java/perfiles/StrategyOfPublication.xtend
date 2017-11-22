package perfiles

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Set

@Accessors
abstract class StrategyOfPublication extends StrategyOfNote{
	
	protected Publication    aNota
	protected ProfileService aService
	
	new(Publication nota, ProfileService service) {
		this.aNota 	  = nota
		this.aService = service
	}
	
	override void execute() 
	
	override void addAndRemove(Set<String> colleccionAAgregar,Set<String> colleccionAQuitar, String aUserId){
		aNota.agregar(colleccionAAgregar,aUserId)
		aNota.quitar(colleccionAQuitar,aUserId)		

	}
	
	
	
}