package perfiles

import java.util.Set

abstract class StrategyOfCommentary implements  StrategyOfNote{
	
	protected Publication 		publication
	protected String 	  		authorWhoPoint
	protected ProfileService	profileService
	protected Comentary			comentary
	
	new(Publication aPublication, String aAuthorWhoPoint, Comentary aComentary, ProfileService aProfileService) {
		this.publication		= aPublication
		this.authorWhoPoint		= aAuthorWhoPoint
		this.profileService		= aProfileService
		this.comentary			= aComentary
	}
	
	override void addAndRemove(Set<String> colleccionAAgregar,Set<String> colleccionAQuitar, String aUserId){
		comentary.agregar(colleccionAAgregar,aUserId)
		comentary.quitar(colleccionAQuitar,aUserId)
	}
	
}