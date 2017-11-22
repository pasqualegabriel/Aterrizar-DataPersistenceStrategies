package perfiles

class MeGustaPublication extends StrategyOfPublication{
	
	String aUserId
	
	new(Publication publication, String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser
	}
	
	override execute() {
		aNota.agregarMeGusta( aUserId)
		aNota.quitarNoMeGusta(aUserId)
		aService.update(aNota)
	}
	
}