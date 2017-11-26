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
	// amigos es la lista de amigos de userName (userName incluido)
	def loadProfile(String userName, String author, List<String> amigos) {
		var result = mongoCollection
			.aggregate('{  $match : {$or: [ { visibilidad: "Publico" },
											{ $and: [ { visibilidad: "SoloAmigos" }, { author: { $in: # } } ] }, 
											{ $and: [ { visibilidad: "Privado" },    { author: # } ] } ] } }',
	    			  							 amigos, userName)
			.and('{ $project: { comentarios: { $filter: { input: "$comentarios", as: "coments", cond: 
				{ $or: [ { $eq:  [ "$$coments.visibilidad", "Publico" ] },  
						 { $and: [ { $eq: [ "$$coments.visibilidad", "SoloAmigos" ] }, 
						           { $in: [ "$$coments.author", # ] } ] },  
						 { $and: [ { $eq: [ "$$coments.visibilidad", "Privado" ] }, 
						           { $eq: [ "$$coments.author", # ] } ] } ] } } }, 
				author:1, visibilidad:1, cuerpo:1, meGustan:1, noMeGustan:1, destino:1 } }',
				      amigos, userName).^as(Publication)
				        
		copyToList(result)
	}

/*
	def loadProfile(String userName, String author, List<String> amigos) {
		var result = mongoCollection
						.aggregate('{  $match : {$or: [ { visibilidad: {$in:["Publico"]} },
							{ $and: [ { visibilidad: {$in:["SoloAmigos"]} }, { author: {$in:#} } ] }, 
							{ $and: [ { visibilidad: {$in:["Privado"]} }, { author: {$in:[#]} } ] }] }  }',
								  amigos, userName)
						.and('{ $project: { comentarios: { $filter: { input: "$comentarios", as: "coments", cond: 
							{$or: [ { $in: [ "$$coments.visibilidad", ["Publico"] ] },  
							{ $and: [ { $in: [ "$$coments.visibilidad", ["SoloAmigos"] ] }, 
							{$in: [ "$$coments.author", # ] } ] },  
							{ $and: [ { $in: [ "$$coments.visibilidad", ["Privado"] ] }, 
							{$in: [ "$$coments.author", [#] ] } ] } ]}} }, 
							author:1, visibilidad:1, cuerpo:1, meGustan:1, noMeGustan:1, destino:1 }}',
							amigos, userName).^as(Publication)  
		copyToList(result)
	}
*/




}



