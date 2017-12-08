package cacheDePerfil

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class KeyDeCacheDePerfil {
	
	String author;
	String observer;
	
	new(String anObserver, String anAuthor) {
		author      = anAuthor
		observer    = anObserver
	}
	
	def generateValue() {
		author+observer
	}
	

}