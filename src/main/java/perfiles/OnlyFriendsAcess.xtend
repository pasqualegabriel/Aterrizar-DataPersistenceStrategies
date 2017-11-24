package perfiles

class OnlyFriendsAcess extends  AccessPermited{
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
			visibilidad.equals(Visibilidad.SoloAmigos) && ( elUsuarioEsAmigoDelAutor(author,anUserName) || elUsuarioEsElAutorDeLapublicacion(author,anUserName))
	}
	
	
	
}


