package perfiles



class OnlyFriendsAcess extends AccessOfPrivacy{
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
			visibilidad.equals(Visibilidad.SoloAmigos) && ( elUsuarioEsAmigoDelAutor(author,anUserName) || elUsuarioEsElAutorDeLapublicacion(author,anUserName))
	}
	
	
	
}