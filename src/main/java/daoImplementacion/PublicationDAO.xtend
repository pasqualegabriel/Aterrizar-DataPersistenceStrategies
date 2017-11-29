package daoImplementacion

import perfiles.Publication
import dao.GenericMongoDAO
import java.util.UUID
import java.util.List
import org.bson.types.ObjectId
import perfiles.Comentary

class PublicationDAO extends GenericMongoDAO<Publication>{
	
	new() {
		super(Publication)
	}
	
	def boolean hayPublicacion(Publication publication) {

		var result = this.find(
					     "{ author: # , destino: { id : #, nombre : # } }", 
					     publication.author, publication.idDestino, publication.nombreDestino)	
		!result.empty
	}

	def tienePermisosParaInteractuarConLaPublicacion(String idPublicacion, String userName, List<String> amigos) {
		var result = mongoCollection.findOne('{ $and: [ { _id: # },
                                                        { $or: [ { author: # },
			                                                     { visibilidad: "Publico" },
											                     { $and: [ { visibilidad: "SoloAmigos" }, 
			                                                               { author: { $in: # } } ] } ] } ] }, 
                             { author:1, visibilidad:0, cuerpo:0, meGustan:0, noMeGustan:0 }', 
                             new ObjectId(idPublicacion), userName, amigos).^as(Publication)
		result != null
	}
	
    def tienePermisosParaInteractuarConElComentario(UUID idCommentary, String userName, List<String> amigos) {
		var result = mongoCollection
			.aggregate('{ $match: { comentarios.id: # } }', 
                      idCommentary)
			.and('{ $project: { comentarios: { $filter: { input: "$comentarios", as: "coments", cond: 
				{ $and: [ { $eq: ["$$coments.id", # ] },
					      { $or: [ { $eq:  [ "$$coments.visibilidad", "Publico" ] },  
						           { $eq:  [ "$$coments.author", # ] }, 
						           { $and: [ { $eq: [ "$$coments.visibilidad", "SoloAmigos" ] }, 
						                     { $in: [ "$$coments.author", # ] } ] } ] } ] } } } } }',
				      idCommentary, userName, amigos).^as(Publication)
				        
		var res = copyToList(result)

		!res.empty && res.get(0).comentarios.size > 0
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
	
	def addComment(String idPublication, Comentary comentary) {

		mongoCollection.update('{ _id: # }', new ObjectId(idPublication))
		.with('{ $push: { comentarios: # } }', comentary)
	}
	
	def agregarMeGustaComentario(UUID idComentario, String userName) {

		mongoCollection.update('{ comentarios.id: # }', idComentario)
		.with('{ $addToSet: { comentarios.$.meGustan: # }}', userName)
	}
	
	def quitarMeGustaComentario(UUID idComentario, String userName) {

		mongoCollection.update('{ comentarios.id: # }', idComentario)
		.with('{ $pull: { comentarios.$.meGustan: # }}', userName)
	}
	
	def agregarNoMeGustaComentario(UUID idComentario, String userName) {

		mongoCollection.update('{ comentarios.id: # }', idComentario)
		.with('{ $addToSet: { comentarios.$.noMeGustan: # }}', userName)
	}
	
	def quitarNoMeGustaComentario(UUID idComentario, String userName) {

		mongoCollection.update('{ comentarios.id: # }', idComentario)
		.with('{ $pull: { comentarios.$.noMeGustan: # }}', userName)
	}
	
	def agregarMeGustaPublicacion(String idPublicacion, String userName) {

		mongoCollection.update('{ _id: # }', new ObjectId(idPublicacion))
		.with('{ $addToSet: { meGustan: # }}', userName)
	}
	
	def quitarMeGustaPublicacion(String idPublicacion, String userName) {

		mongoCollection.update('{ _id: # }', new ObjectId(idPublicacion))
		.with('{ $pull: { meGustan: # }}', userName)
	}
	
	def agregarNoMeGustaPublicacion(String idPublicacion, String userName) {

		mongoCollection.update('{ _id: # }', new ObjectId(idPublicacion))
		.with('{ $addToSet: { noMeGustan: # }}', userName)
	}
	
	def quitarNoMeGustaPublicacion(String idPublicacion, String userName) {

		mongoCollection.update('{ _id: # }', new ObjectId(idPublicacion))
		.with('{ $pull: { noMeGustan: # }}', userName)
	}


}



