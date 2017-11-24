package perfiles

class NoMeGustaPublication extends StrategyOfPublication {
	
	String aUserId
	
	new( String aUser, ProfileService service) {
		super( service)
		aUserId = aUser
	}
	
	override execute() {
		aNota.agregarNoMeGusta(aUserId)
		aNota.quitarMeGusta(   aUserId)
		aService.update(aNota)
	}
	
}