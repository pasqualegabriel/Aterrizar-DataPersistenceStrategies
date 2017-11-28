package perfiles

class MeGustaComnentary extends PublicationOfCommentary{

	new(){}

	override execute() {
	
		profileService.agregarMeGusta( comentary.id, aUserId)
		profileService.quitarNoMeGusta(comentary.id, aUserId)
		
	}
	

	
}