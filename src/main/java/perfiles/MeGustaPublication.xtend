package perfiles

class MeGustaPublication extends PublicationOfNote{
	
	new( String aUser, ProfileService service) {
		this.profileService= service
		aUserId = aUser
	}
	
	override execute() {
		publication.agregarMeGusta( aUserId)
		publication.quitarNoMeGusta(aUserId)
		profileService.update(publication)
	}
	
}