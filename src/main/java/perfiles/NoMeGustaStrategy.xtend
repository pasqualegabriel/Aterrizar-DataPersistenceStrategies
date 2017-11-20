package perfiles

class NoMeGustaStrategy extends StrategyOfPublication {
	
	String aUserId
	
	new(Publication publication, String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser;
	}
	
	override execute() {
		aNota.quitar(aNota.meGustan,aUserId)
		aNota.agregar(aNota.noMeGustan,aUserId)
		aService.update(aNota)
	}
	
}