package daoImplementacion

import dao.GenericMongoDAO
import service.Profile
import perfiles.Comentario

class ProfileDAO extends GenericMongoDAO<Profile> {

	new() {
		super(Profile)
	}

	def dameNombrePLISS(String string, String string2, Comentario comentario) {
	}

	
	def void update(Profile aProfile) {
		this.mongoCollection.save(aProfile)
	}
	
	override Profile load(String user) {
		mongoCollection.findOne("{usuario:'"+  user +"'}").^as(entityType);
				
	}
}
