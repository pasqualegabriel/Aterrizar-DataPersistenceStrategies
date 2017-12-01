package perfiles

import Excepciones.ExceptionYaExisteUnaPublicacionSobreElDestino

class YaPublico implements StateOfTheNewPublication {
	
	override canHandle(Publication publication, ProfileService service) {
		service.sePublico(publication)
	}
	
	override execute(Publication publication, ProfileService service) {
		throw new ExceptionYaExisteUnaPublicacionSobreElDestino("Ya existe una publicacion sobre el destino")
	}
}