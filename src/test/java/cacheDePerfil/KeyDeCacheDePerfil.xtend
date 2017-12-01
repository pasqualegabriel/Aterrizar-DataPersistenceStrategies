package cacheDePerfil

import perfiles.Visibilidad

class KeyDeCacheDePerfil {
	
	String userName;
	Visibilidad visibilidad;
	
	new(String unUserName, Visibilidad unaVisibilidad) {
		userName    = unUserName
		visibilidad = unaVisibilidad
	}
	
	def generateValue() {
		userName+visibilidad.toString
	}
	
}