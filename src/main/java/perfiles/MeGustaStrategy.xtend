package perfiles

class MeGustaStrategy extends StrategyOfPublication{
	
	String aUserId
	
	new(Publication publication, String aUser, ProfileService service) {
		super(publication, service)
		aUserId = aUser;
	}
	
	override execute() {
		//Logica repetida con noMeGustaStrategy
		aNota.quitar(aNota.noMeGustan,aUserId)
		aNota.agregar(aNota.meGustan,aUserId)		
		aService.update(aNota)
	}
	
}