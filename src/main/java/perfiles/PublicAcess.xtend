package perfiles

class PublicAcess extends AccessOfPrivacy {
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
		visibilidad.equals(Visibilidad.Publico)
	}
	
	
	
}




