package perfiles


interface StateOfTheNewPublication {
	
	def Boolean canHandle( Boolean sePublico, Boolean seVisito)
	
	def Publication execute(Publication publication, ProfileService service)
}