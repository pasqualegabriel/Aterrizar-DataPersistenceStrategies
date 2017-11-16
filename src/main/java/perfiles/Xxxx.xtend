package perfiles

import daoImplementacion.ProfileDAO
import daoImplementacion.HibernateUserDAO
import runner.Runner
import Excepciones.ExceptionNoVisitoDestino

class Xxxx implements PerfilService{
	
	ProfileDAO  		profileDAO
	HibernateUserDAO 	hibernateUserDAO
	
	new(ProfileDAO aProfileDAO,HibernateUserDAO aHibernateUserDAO) {
		this.profileDAO			= aProfileDAO
		this.hibernateUserDAO	= aHibernateUserDAO
	}
	
	override agregarPublicación(String aUser, Publicacion aPublication) {
		
		Runner.runInSession [	
			if(!hibernateUserDAO.visito(aUser, aPublication.destino.id)){
				throw new ExceptionNoVisitoDestino("No puede publicar sin haber visitado el destino")
			}
		]
		var profile = profileDAO.load(aUser)
		profile.publicar(aPublication)
	
		profileDAO.update(profile)
	
		aPublication
		
	}
	
	override agregarComentario(String aUser, int aPublication, Comentario aComentary) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override meGusta(String aUser, Integer publicacion) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override noMeGusta(String aUser, Integer publicacion) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override meGusta(String aUser, int comentario) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override noMeGusta(String aUser, int comentario) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override verPerfil(String aUser, String otherUser) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}