package perfiles

//Responsabilidad: loTieneQuePonerGabi

interface CanPublish {
	
	def Boolean canHandle(Publication publication, ProfileService service)
	
	def Publication execute(Publication publication, ProfileService service)
}