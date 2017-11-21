package perfiles

class MeGustaComnentary  extends StrategyOfCommentary{
	
	
	
	
	new(Publication aPublication, String aAuthorWhoPoint, Comentary aComentary, ProfileService aProfileService) {
		super(aPublication,aAuthorWhoPoint,aComentary,aProfileService)
	}
	
	override execute() {
		this.addAndRemove(comentary.meGustan,comentary.noMeGustan,authorWhoIsRating)
		profileService.update(publication)	
	}
	

	
}