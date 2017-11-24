package perfiles

class NoMeGustaPublication extends PublicationOfNote {
	
	
	
	new( String aUser, ProfileService service) {
		aUserId = aUser
		profileService = service
	}
	
	override execute() {
		publication.agregarNoMeGusta(aUserId)
		publication.quitarMeGusta(   aUserId)
		profileService.update(publication)
	}
	
}