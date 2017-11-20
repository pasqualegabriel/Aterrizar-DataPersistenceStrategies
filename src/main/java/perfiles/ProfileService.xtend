package perfiles


import daoImplementacion.HibernateUserDAO
import daoImplementacion.PublicationDAO
import runner.Runner
import Excepciones.ExceptionNoVisitoDestino
import daoImplementacion.UserNeo4jDAO
import Excepciones.ExceptionYaExisteUnaPublicacionSobreElDestino
//import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion
import daoImplementacion.ComentaryDAO
import java.util.UUID


class ProfileService implements PerfilService{
	
	HibernateUserDAO 	hibernateUserDAO
	PublicationDAO		publicationDAO
	ComentaryDAO        comentaryDAO
	UserNeo4jDAO        neo4jDao
	
	new(PublicationDAO aPublicationDAO, ComentaryDAO aComentaryDAO, HibernateUserDAO aHibernateUserDAO, UserNeo4jDAO aUserNeo4jDAO) {
		this.hibernateUserDAO	= aHibernateUserDAO
		this.publicationDAO		= aPublicationDAO
		this.comentaryDAO       = aComentaryDAO	
		this.neo4jDao           = aUserNeo4jDAO
	}
	
	override agregarPublicación(String aUser, Publication aPublication) {
		
		chequearSiYaPublico(aUser, aPublication)
		chequearSiNoVisitoDestino(aUser, aPublication)
		
		aPublication.author	= aUser
		publicationDAO.save(aPublication)

		aPublication
	}
	
	def chequearSiYaPublico(String aUser, Publication aPublication) {
		if(sePublico(aUser, aPublication)){
			throw new ExceptionYaExisteUnaPublicacionSobreElDestino("Ya existe una publicacion sobre el destino")
		}
	}
	
	def chequearSiNoVisitoDestino(String aUser, Publication aPublication) {
		if(!visito(aUser, aPublication)){
			throw new ExceptionNoVisitoDestino("No puede publicar sin haber visitado el destino")
		}
	}
	
	def sePublico(String aUser, Publication aPublication) {
		publicationDAO.hayPublicacion(aUser,aPublication)
	}
	
	
	def visito(String aUser, Publication aPublication) {
		Runner.runInSession [
			hibernateUserDAO.visito(aUser, aPublication.destino.id) 
		]
	}
	
	override agregarComentario(String anIdPublication, Comentary aComentary) {
		
		//buscamos la publicacion
		val unaPublicacion = publicationDAO.load(anIdPublication) 
		
		//Utilizamos un manejador de Privacidad que se responsabiliza de hacerse cargo de proveer el comportamiento
		//Correcto dependiendo la privacidad de la publicacion.
		val strategy       = new CommentaryStrategy(aComentary,unaPublicacion, this) 
		new PrivacyHandler => [ hasPermission(unaPublicacion, strategy, aComentary.author) ]
	
		aComentary
	}
	
	override meGusta(String aUser, String anIdPublication) {
			
		//buscamos la publicacion
		val unaPublicacion = publicationDAO.load(anIdPublication) 
		
		//Utilizamos un manejador de Privacidad que se responsabiliza de hacerse cargo de proveer el comportamiento
		//Correcto dependiendo la privacidad de la publicacion.
		val strategy       = new MeGustaStrategy(unaPublicacion, aUser, this) 
		new PrivacyHandler => [ hasPermission(unaPublicacion, strategy, aUser) ]
	}

	
	override noMeGusta(String aUser, String anIdPublication) {
		//buscamos la publicacion
		val unaPublicacion = publicationDAO.load(anIdPublication) 
		
		//Utilizamos un manejador de Privacidad que se responsabiliza de hacerse cargo de proveer el comportamiento
		//Correcto dependiendo la privacidad de la publicacion.
		val strategy       = new NoMeGustaStrategy(unaPublicacion, aUser, this) 
		new PrivacyHandler => [ hasPermission(unaPublicacion, strategy, aUser) ]
	}
	
	override verPerfil(String aUser, String otherUser) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	def publicitarComentario(Publication publication, Comentary aComentary) {
		
		aComentary.id =  UUID.randomUUID
		publication.agregarComentario(aComentary)
		
		publicationDAO.update(publication)
	}

	def update(Publication publication){
		publicationDAO.update(publication)
	}
	
	override meGusta(String aUser, UUID idCommentary) {
//		var Publication aPublication = publicationDAO.loadForCommentary(idCommentary)
//		var aCommentary  = aPublication.searchCommentary(idCommentary)
//		
//		val strategy       = new MeGustaStrategy(aPublication, aUser, aCommentary, this)  
//		new PrivacyHandler => [ hasPermission(aCommentary, strategy, aUser) ]
		
	}
	
	override noMeGusta(String aUser, UUID idCommentary) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}


	
}




