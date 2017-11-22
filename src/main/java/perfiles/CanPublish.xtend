package perfiles

interface CanPublish {
	
	def Boolean canHandle(String aUserName, Publication publication, ProfileService service)
	
	def Publication execute(String aUserName, Publication publication, ProfileService service)
}