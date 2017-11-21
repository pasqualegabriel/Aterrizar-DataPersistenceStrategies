package perfiles

import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion

class AcessDenied extends AccessOfPrivacy {
		
	override canHandle(Visibilidad visibilidad, String author, String anUserName) { 
		true
	}
	
	override assertRule (StrategyOfNote strategy) {
		throw new ExceptionNoTienePermisoParaInteractuarConLaPublicacion("El usuario no tiene permiso para interactuar con la publicacion")
	}
	
}