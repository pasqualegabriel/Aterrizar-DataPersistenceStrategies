package perfiles

class AcessDenied extends AccessOfPrivacy {
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) { 
		(visibilidad.equals(Visibilidad.Privado) && !elUsuarioEsElAutorDeLapublicacion(author,anUserName)) ||
		(visibilidad.equals(Visibilidad.SoloAmigos) && !elUsuarioEsAmigoDelAutor(author,anUserName)) && !elUsuarioEsElAutorDeLapublicacion(author,anUserName)
	}
	
	override assertRule(PublicationOfNote strategy) {
		strategy.negateAccess
	}
	
	
}



