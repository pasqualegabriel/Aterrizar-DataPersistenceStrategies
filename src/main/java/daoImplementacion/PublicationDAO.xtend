package daoImplementacion

import perfiles.Publication
import dao.GenericMongoDAO

class PublicationDAO extends GenericMongoDAO<Publication>{
	
	new() {
		super(Publication)
	}
	
	def boolean hayPublicacion(String aUserName, Publication publication) {

		var result = this.find(
					     "{userProprietor: # , destino: { id : #, nombre : # } }", 
					     aUserName, publication.idDestino, publication.nombreDestino)	
		     	
		result.length != 0
	}

	
}