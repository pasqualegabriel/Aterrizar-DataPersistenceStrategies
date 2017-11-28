package perfiles

class NoMeGustaComnentary extends PublicationOfCommentary{
	
	new(){}
		
	override execute() {

		profileService.agregarNoMeGusta(comentary.id, aUserId)
		profileService.quitarMeGusta(   comentary.id, aUserId)
	}
	
	
	
}