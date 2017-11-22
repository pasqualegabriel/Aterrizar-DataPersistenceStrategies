package perfiles

class NoMeGustaPublication extends StrategyOfPublication {
	
	String aUserId
	
	new(Publication publication, String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser
	}
	
	override execute() {
		aNota.agregarNoMeGusta(aUserId)
		aNota.quitarMeGusta(   aUserId)
		aService.update(aNota)
	}
	
}