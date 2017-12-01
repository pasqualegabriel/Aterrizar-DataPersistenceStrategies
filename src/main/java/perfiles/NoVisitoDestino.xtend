package perfiles

import Excepciones.ExceptionNoVisitoDestino

class NoVisitoDestino implements StateOfTheNewPublication {
	
	override canHandle(Publication publication, ProfileService service) {
		!service.visito(publication)
	}
	
	override execute(Publication publication, ProfileService service) {
		throw new ExceptionNoVisitoDestino("No puede publicar sin haber visitado el destino")
	}
}