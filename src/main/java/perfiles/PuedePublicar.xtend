package perfiles

class PuedePublicar implements CanPublish {
	
	override canHandle(String aUserName, Publication publication, ProfileService service) {
		!service.sePublico(aUserName, publication) && service.visito(aUserName, publication)
	}
	
	override execute(String aUserName, Publication publication, ProfileService service) {
		publication.author = aUserName
		service.save(publication)

		publication
	}
}