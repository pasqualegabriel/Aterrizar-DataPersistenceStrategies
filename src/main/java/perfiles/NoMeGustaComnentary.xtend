package perfiles

class NoMeGustaComnentary  extends StrategyOfCommentary{
	
	new(){}
	
	new(Publication aPublication, String aAuthorWhoPoint, Comentary aComentary, ProfileService aProfileService) {
		super(aPublication, aAuthorWhoPoint, aComentary, aProfileService)
	}
	
	override execute() {
		comentary.agregarNoMeGusta(authorWhoIsRating)
		comentary.quitarMeGusta(authorWhoIsRating)
		profileService.update(publication)	
	}
	
	
	
}