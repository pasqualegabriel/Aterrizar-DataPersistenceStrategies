package perfiles

class MeGustaPublication extends StrategyOfPublication{
	
	String aUserId
	
	new( String aUser, ProfileService service) {
		super(service)
		aUserId = aUser
	}
	
	override execute() {
		aNota.agregarMeGusta( aUserId)
		aNota.quitarNoMeGusta(aUserId)
		aService.update(aNota)
	}
	
}