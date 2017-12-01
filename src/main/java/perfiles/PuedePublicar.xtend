package perfiles

class PuedePublicar implements StateOfTheNewPublication {
	
	override canHandle(Boolean sePublico, Boolean seVisito) {
		!sePublico && seVisito
	}
	
	override execute(Publication publication, ProfileService service) {
		service.save(publication)
		publication
	}
}