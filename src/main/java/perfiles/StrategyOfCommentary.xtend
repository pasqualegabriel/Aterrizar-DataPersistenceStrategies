package perfiles

class StrategyOfCommentary extends PublicationOfNote{
		
	protected Comentary			comentary
	
	new(){}
	
	new(Publication aPublication, String anAuthorWhoIsRating, Comentary aComentary, ProfileService aProfileService) {
		this.initialize(aPublication, anAuthorWhoIsRating, aComentary, aProfileService)
	}
	
	new(Comentary comentary, ProfileService service) {
		this.comentary= comentary
		this.profileService = service
	}
	
	def initialize(Publication aPublication, String anAuthorWhoIsRating, Comentary aComentary, ProfileService aProfileService){
		this.publication		= aPublication
		this.aUserId	        = anAuthorWhoIsRating
		this.profileService		= aProfileService
		this.comentary			= aComentary
	}
	

	override execute() {
		profileService.publicitarComentario(publication,comentary)
	}
}


