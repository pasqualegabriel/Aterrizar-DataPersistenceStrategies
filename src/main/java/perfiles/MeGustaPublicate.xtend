package perfiles

class MeGustaPublicate extends StrategyOfPublication{
	
	String aUserId
	
	new(Publication publication, String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser;
	}
	
	override execute() {
		this.addAndRemove(aNota.meGustan,aNota.noMeGustan,aUserId )
		aService.update(aNota)
	}
	
}