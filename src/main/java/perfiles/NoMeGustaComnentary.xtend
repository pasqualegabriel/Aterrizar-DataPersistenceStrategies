package perfiles

class NoMeGustaComnentary  extends PublicationOfCommentary{
	
	new(){}
		
	override execute() {
		comentary.agregarNoMeGusta(aUserId)
		comentary.quitarMeGusta(aUserId)
		profileService.update(publication)	
	}
	
	
	
}