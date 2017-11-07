package unq.amistad

import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mensaje {
	
	String cuerpo
	LocalDateTime fecha
	
	new(String unCuerpo, LocalDateTime unaFecha){
		cuerpo= unCuerpo
		fecha = unaFecha
	}
	
}