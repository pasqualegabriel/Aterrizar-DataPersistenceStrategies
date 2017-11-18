package perfiles

import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion

class AcessDenied extends AccessOfPrivacy {
		
	override canHandle(Visibilidad visibilidad, String author, String anUserName) { 
		(!elUsuarioEsAmigoDelAutor(author,anUserName) && !elUsuarioEsElAutorDeLapublicacion(author,anUserName) && !visibilidad.equals(Visibilidad.Publico))
	}
	
	override assertRule (StrategyOfPublication strategy) {
		throw new ExceptionNoTienePermisoParaInteractuarConLaPublicacion("El usuario no tiene permiso para interactuar con la publicacion")
	}
	
}