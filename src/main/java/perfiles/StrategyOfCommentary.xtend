package perfiles

import java.util.Set

abstract class StrategyOfCommentary extends  StrategyOfNote{
	
	protected Publication 		publication
	protected String 	  		authorWhoIsRating
	protected ProfileService	profileService
	protected Comentary			comentary
	
	new(Publication aPublication, String anAuthorWhoIsRating, Comentary aComentary, ProfileService aProfileService) {
		this.publication		= aPublication
		this.authorWhoIsRating	= anAuthorWhoIsRating
		this.profileService		= aProfileService
		this.comentary			= aComentary
	}
	
	override void addAndRemove(Set<String> colleccionAAgregar,Set<String> colleccionAQuitar, String aUserId){
		comentary.agregar(colleccionAAgregar,aUserId)
		comentary.quitar(colleccionAQuitar,aUserId)
	}
	
}