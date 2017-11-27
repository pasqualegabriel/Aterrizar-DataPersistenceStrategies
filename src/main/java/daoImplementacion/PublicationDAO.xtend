package daoImplementacion

import perfiles.Publication
import dao.GenericMongoDAO
import java.util.UUID
import java.util.List

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
			
		var result=find("{ comentarios.id: # }", idCommentary)
		result.get(0)
	}
	
	def loadAllPublications(String userName) {
				
		var result=find("{ author: # }", userName)
		result
	}
	
	// userName es quien busca el perfil del author
	// amigos es la lista de amigos de userName (userName no incluido)
	def loadProfile(String userName, String author, List<String> amigos) {
		var result = mongoCollection
			.aggregate('{ $match: { $and: [ { author: # },
                                            { $or: [ { visibilidad: "Publico" },
								                     { author: # },
								 	                 { $and: [ { visibilidad: "SoloAmigos" }, 
                                                               { author: { $in: # } } ] } ] } ] } }', 
                      author, userName, amigos)
			.and('{ $project: { comentarios: { $filter: { input: "$comentarios", as: "coments", cond: 
				{ $or: [ { $eq:  [ "$$coments.visibilidad", "Publico" ] },  
						 { $eq:  [ "$$coments.author", # ] }, 
						 { $and: [ { $eq: [ "$$coments.visibilidad", "SoloAmigos" ] }, 
						           { $in: [ "$$coments.author", # ] } ] } ] } } }, 
				author:1, visibilidad:1, cuerpo:1, meGustan:1, noMeGustan:1, destino:1 } }',
				      userName, amigos).^as(Publication)
				        
		copyToList(result)
	}


}



