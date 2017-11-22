package perfiles

import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion

abstract class StrategyOfNote {
	
	def void execute()

	def void negateAccess(){
		throw new ExceptionNoTienePermisoParaInteractuarConLaPublicacion("El usuario no tiene permiso para interactuar con la publicacion")
	}
	
	
}

