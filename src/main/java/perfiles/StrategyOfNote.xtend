package perfiles

import java.util.Set
import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion


abstract class StrategyOfNote {
	def void execute()
	
	// Nahuel revisar.
	def void addAndRemove(Set<String> colleccionAAgregar,Set<String> colleccionAQuitar, String aUserId)
	
	def void negateAccess(){
		
		throw new ExceptionNoTienePermisoParaInteractuarConLaPublicacion("El usuario no tiene permiso para interactuar con la publicacion")
	
	}
}