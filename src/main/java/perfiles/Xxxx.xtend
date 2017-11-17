package perfiles


import daoImplementacion.HibernateUserDAO
import daoImplementacion.PublicationDAO
import runner.Runner
import Excepciones.ExceptionNoVisitoDestino

class Xxxx implements PerfilService{
	

	HibernateUserDAO 	hibernateUserDAO
	PublicationDAO		publicationDAO
	
	new(PublicationDAO aPublicationDAO, HibernateUserDAO aHibernateUserDAO) {
		this.hibernateUserDAO	= 	aHibernateUserDAO
		this.publicationDAO		=	aPublicationDAO	
	}
	
	override agregarPublicación(String aUser, Publication aPublication) {
			
		if(this.noVisitoDestinoOYaPublico(aUser,aPublication) ){
			throw new ExceptionNoVisitoDestino("No puede publicar sin haber visitado el destino")
		}
		
		aPublication.userProprietor	= aUser
		publicationDAO.save(aPublication)

		aPublication
		
	}
	
	def noVisitoDestinoOYaPublico(String aUser, Publication aPublication) {
		 
		 this.sePublico(aUser,aPublication)	|| !this.visito(aUser, aPublication)
	}
	
	def sePublico(String aUser, Publication aPublication) {
		publicationDAO.hayPublicacion(aUser,aPublication)
	}
	
	
	def visito(String aUser, Publication aPublication) {
		Runner.runInSession [
			hibernateUserDAO.visito(aUser, aPublication.destino.id) 
		]
	}
	
	override agregarComentario(String aUser, int aPublication, Comentary aComentary) {
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