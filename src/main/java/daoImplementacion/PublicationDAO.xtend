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
	
	def boolean hayPublicacion(String aUserName, Publication publication) {

		var result = this.find(
					     "{ author: # , destino: { id : #, nombre : # } }", 
					     aUserName, publication.idDestino, publication.nombreDestino)	
		!result.empty
	}
	
//	def loadForCommentary2(UUID idCommentary) {
//			
//		var result=find("{ comentarios.id: # }", idCommentary)
//		result.get(0)
//	}
	
	def loadForCommentary(UUID idCommentary) {
			
		mongoCollection.findOne("{ comentarios.id: # }, 
                                 { author:1, visibilidad:1, cuerpo:0, meGustan:0, noMeGustan:0 }", 
                                 idCommentary).^as(Publication)
//		var result = mongoCollection
//			.aggregate('{ $match: { comentarios.id: # } }', 
//                      idCommentary)
//			.and('{ $project: { comentarios: { $filter: { input: "$comentarios", as: "coments", cond: 
//				  {	$eq:  [ "$$coments.id", # ] } } }, 
//				  author:1, visibilidad:1, cuerpo:0, meGustan:0, noMeGustan:0 } }',
//				      idCommentary).^as(Publication)
//				        
//		copyToList(result).get(0)
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
	
	def loadWithOnlyTheVisibilityAndTheAuthor(String idPublication) {
		
		mongoCollection.findOne("{ _id: # }, { author: 1, visibilidad: 1 }", new ObjectId(idPublication)).^as(Publication)
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



