package perfiles

import Excepciones.ExceptionYaExisteUnaPublicacionSobreElDestino

class YaPublico implements StateOfTheNewPublication {
	
	override canHandle(Boolean sePublico, Boolean seVisito ) {
		sePublico
	}
	
	override execute(Publication publication, ProfileService service) {
		throw new ExceptionYaExisteUnaPublicacionSobreElDestino("Ya existe una publicacion sobre el destino")
	}
}