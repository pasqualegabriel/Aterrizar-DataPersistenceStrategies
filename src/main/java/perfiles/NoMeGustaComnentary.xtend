package perfiles

class NoMeGustaComnentary  extends StrategyOfCommentary{
	
	new(Publication aPublication, String aAuthorWhoPoint, Comentary aComentary, ProfileService aProfileService) {
		super(aPublication, aAuthorWhoPoint, aComentary, aProfileService)
	}
	
	override execute() {
		this.addAndRemove(comentary.noMeGustan,comentary.meGustan,authorWhoPoint)
		profileService.update(publication)	
	}
	
}