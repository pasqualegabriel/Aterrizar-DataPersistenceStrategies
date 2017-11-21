package perfiles

class NoMeGustaStrategy extends StrategyOfPublication {
	
	String aUserId
	
	new(Publication publication, String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser;
	}
	
	override execute() {
		this.addAndRemove(aNota.noMeGustan,aNota.meGustan,aUserId )
		aService.update(aNota)
	}
	
}