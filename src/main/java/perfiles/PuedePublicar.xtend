package perfiles

class PuedePublicar implements StateOfTheNewPublication {
	
	override canHandle(Publication publication, ProfileService service) {
		!service.sePublico(publication) && service.visito(publication)
	}
	
	override execute(Publication publication, ProfileService service) {
		service.save(publication)
		publication
	}
}