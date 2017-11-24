package perfiles

class PublicAcess extends  AccessPermited {
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
		visibilidad.equals(Visibilidad.Publico)
	}
	
	
	
}




