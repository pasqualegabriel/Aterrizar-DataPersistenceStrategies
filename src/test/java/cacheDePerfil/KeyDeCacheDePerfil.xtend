package cacheDePerfil

class KeyDeCacheDePerfil {
	
	String author;
	String observer;
	
	new(String anObserver, String anAuthor) {
		author      = anAuthor
		observer    = anObserver
	}
	
	def generateValue() {
		author + observer
	}
	
}