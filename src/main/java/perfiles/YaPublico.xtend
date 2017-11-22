package perfiles

import Excepciones.ExceptionYaExisteUnaPublicacionSobreElDestino

class YaPublico implements CanPublish {
	
	override canHandle(String aUserName, Publication publication, ProfileService service) {
		service.sePublico(aUserName, publication)
	}
	
	override execute(String aUserName, Publication publication, ProfileService service) {
		throw new ExceptionYaExisteUnaPublicacionSobreElDestino("Ya existe una publicacion sobre el destino")
	}
}