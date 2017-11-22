package perfiles

abstract class StrategyOfCommentary extends StrategyOfNote{
	
	protected Publication 		publication
	protected String 	  		authorWhoIsRating
	protected ProfileService	profileService
	protected Comentary			comentary
	
	new(){}
	
	new(Publication aPublication, String anAuthorWhoIsRating, Comentary aComentary, ProfileService aProfileService) {
		this.initialize(aPublication, anAuthorWhoIsRating, aComentary, aProfileService)
	}
	
	def initialize(Publication aPublication, String anAuthorWhoIsRating, Comentary aComentary, ProfileService aProfileService){
		this.publication		= aPublication
		this.authorWhoIsRating	= anAuthorWhoIsRating
		this.profileService		= aProfileService
		this.comentary			= aComentary
	}
	

}


