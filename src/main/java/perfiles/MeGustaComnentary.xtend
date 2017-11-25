package perfiles

class MeGustaComnentary extends PublicationOfCommentary{

	new(){}

	override execute() {
		comentary.agregarMeGusta(aUserId)
		comentary.quitarNoMeGusta(aUserId)
		profileService.update(publication)	
	}
	

	
}