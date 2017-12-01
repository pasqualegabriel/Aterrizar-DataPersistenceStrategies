package perfiles


interface StateOfTheNewPublication {
	
	def Boolean canHandle(  Publication publication, ProfileService service)
	
	def Publication execute(Publication publication, ProfileService service)
}