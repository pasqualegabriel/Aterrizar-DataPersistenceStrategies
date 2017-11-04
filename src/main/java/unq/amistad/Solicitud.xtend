package unq.amistad

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Solicitud {
	
	String 				emisor
	String 				receptor
	String 				Fecha
	EstadoDeSolicitud	estadoDeSolicitud;
	
	new(String unaFecha, String unEmisor, String unReceptor, EstadoDeSolicitud aState) {
		super()
		fecha   			= unaFecha
		emisor  			= unEmisor
		receptor			= unReceptor
		estadoDeSolicitud	= aState
	}
	
}