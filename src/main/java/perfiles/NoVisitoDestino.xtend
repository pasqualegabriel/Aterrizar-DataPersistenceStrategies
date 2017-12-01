package perfiles

import Excepciones.ExceptionNoVisitoDestino

class NoVisitoDestino implements StateOfTheNewPublication {
	
	override canHandle(Boolean sePublico, Boolean seVisito) {
		!seVisito
	}
	
	override execute(Publication publication, ProfileService service) {
		throw new ExceptionNoVisitoDestino("No puede publicar sin haber visitado el destino")
	}
}