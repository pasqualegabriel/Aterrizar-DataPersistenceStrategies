package daoImplementacion

import perfiles.Comentary
import dao.GenericMongoDAO

class ComentaryDAO extends GenericMongoDAO<Comentary>{
	
	new() {
		super(Comentary)
	}
	
}