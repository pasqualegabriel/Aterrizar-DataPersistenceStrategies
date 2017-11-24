package perfiles

class PrivateAcess extends  AccessPermited {
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
		visibilidad.equals(Visibilidad.Privado) && elUsuarioEsElAutorDeLapublicacion(author,anUserName)
	}
	
}