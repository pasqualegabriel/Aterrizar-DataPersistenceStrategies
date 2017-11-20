package daoImplementacion

import perfiles.Publication
import dao.GenericMongoDAO
import java.util.UUID

class PublicationDAO extends GenericMongoDAO<Publication>{
	
	new() {
		super(Publication)
	}
	
	def boolean hayPublicacion(String aUserName, Publication publication) {

		var result = this.find(
					     "{author: # , destino: { id : #, nombre : # } }", 
					     aUserName, publication.idDestino, publication.nombreDestino)	
		     	
		!result.empty
	}
	
	def loadForCommentary(UUID idCommentary) {
		
//		var result = this.find(
//					     "{  }", 
//					     aUserName, publication.idDestino, publication.nombreDestino)	
//		     	
//		!result.empty
		new Publication
	}




}



