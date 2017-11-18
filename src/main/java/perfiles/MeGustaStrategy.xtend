package perfiles

class MeGustaStrategy extends StrategyOfPublication{
	
	String aUserId
	
	new(Publication publication,String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser;
	}
	
	override execute() {
		aService.publicitarMeGusta(aPublication,aUserId)
	}
	
}