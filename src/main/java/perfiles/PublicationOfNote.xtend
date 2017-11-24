package perfiles

import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion

abstract class PublicationOfNote {
	
	protected Publication 		publication
	protected ProfileService	profileService
	protected String aUserId
	
	def void execute()

	def void negateAccess(){
		throw new ExceptionNoTienePermisoParaInteractuarConLaPublicacion("El usuario no tiene permiso para interactuar con la publicacion")
	}
	
	
}

