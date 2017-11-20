package perfiles

class NoMeGustaStrategy extends StrategyOfPublication {
	
	String aUserId
	
	new(Publication publication, String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser;
	}
	
	override execute() {
		aService.publicitarNoMeGusta(aPublication, aUserId)
	}
	
}