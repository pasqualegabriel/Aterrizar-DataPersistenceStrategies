package perfiles

import Excepciones.ExceptionNoVisitoDestino

class NoVisitoDestino implements CanPublish {
	
	override canHandle(String aUserName, Publication publication, ProfileService service) {
		!service.visito(aUserName, publication)
	}
	
	override execute(String aUserName, Publication publication, ProfileService service) {
		throw new ExceptionNoVisitoDestino("No puede publicar sin haber visitado el destino")
	}
}