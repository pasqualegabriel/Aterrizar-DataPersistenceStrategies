package perfiles

class PuedePublicar implements CanPublish {
	
	override canHandle(Publication publication, ProfileService service) {
		!service.sePublico(publication) && service.visito(publication)
	}
	
	override execute(Publication publication, ProfileService service) {
		service.save(publication)
		publication
	}
}