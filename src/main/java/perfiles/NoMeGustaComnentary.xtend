package perfiles

class NoMeGustaComnentary  extends StrategyOfCommentary{
	
	new(){}
	
	new(Publication aPublication, String aAuthorWhoPoint, Comentary aComentary, ProfileService aProfileService) {
		super(aPublication, aAuthorWhoPoint, aComentary, aProfileService)
	}
	
	override execute() {
		comentary.agregarNoMeGusta(aUserId)
		comentary.quitarMeGusta(aUserId)
		profileService.update(publication)	
	}
	
	
	
}