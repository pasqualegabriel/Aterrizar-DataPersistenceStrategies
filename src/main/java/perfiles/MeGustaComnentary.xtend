package perfiles

class MeGustaComnentary extends StrategyOfCommentary{

	new(){}

	new(Publication aPublication, String aAuthorWhoPoint, Comentary aComentary, ProfileService aProfileService) {
		super(aPublication,aAuthorWhoPoint,aComentary,aProfileService)
	}

	override execute() {
		comentary.agregarMeGusta(aUserId)
		comentary.quitarNoMeGusta(aUserId)
		profileService.update(publication)	
	}
	

	
}