package perfiles

import daoImplementacion.HibernateUserDAO
import daoImplementacion.PublicationDAO
import runner.Runner
import java.util.UUID
import unq.amistad.RelacionesDeAmistades
import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion
import Excepciones.ExceptionNoTienePermisoParaInteractuarConElComentario

class ProfileService implements PerfilService {
	
	HibernateUserDAO 	  hibernateUserDAO
	PublicationDAO		  publicationDAO
    RelacionesDeAmistades relacionesDeAmistades
	
	new(PublicationDAO aPublicationDAO, HibernateUserDAO aHibernateUserDAO) {
		this.hibernateUserDAO	   = aHibernateUserDAO
		this.publicationDAO		   = aPublicationDAO
        this.relacionesDeAmistades = new RelacionesDeAmistades
	}
	
	override agregarPublicación(Publication aPublication) {
		
		var newPublication = new NewPublication 
		newPublication.canPublish(aPublication, this)
	}
	
	def sePublico(Publication aPublication) {
		publicationDAO.hayPublicacion(aPublication)
	}
	
	def visito(Publication aPublication) {
		Runner.runInSession [
			hibernateUserDAO.visito(aPublication.author, aPublication.destino.id) 
		]
	}

	override agregarComentario(String anIdPublication, Comentary aComentary) {
		
//		val command = new PublicationOfCommentary(aComentary, this) 
//		publicitarNota(anIdPublication, command, aComentary.author)
		verifyPermissions(anIdPublication, aComentary.author)
		publicitarComentario(anIdPublication, aComentary)
	
		aComentary
	}

	override meGusta(String aUser, String anIdPublication) {
		
//		val command = new MeGustaPublication(aUser, this) 
//		publicitarNota(anIdPublication, command, aUser)
		verifyPermissions(anIdPublication, aUser)
		publicationDAO.agregarMeGustaPublicacion( anIdPublication, aUser)
		publicationDAO.quitarNoMeGustaPublicacion(anIdPublication, aUser)
	}
	
	def havePermissions(String anIdPublication, String aUser) {
		var amigos = amigos(aUser)
		publicationDAO.tienePermisosParaInteractuarConLaPublicacion(anIdPublication, aUser, amigos)
	}
	
	def amigos(String aUser) {
		relacionesDeAmistades.userNames(aUser)
	}

	override noMeGusta(String aUser, String anIdPublication) {
		
//		val command = new NoMeGustaPublication(aUser, this) 
//		publicitarNota(anIdPublication, command, aUser)
		verifyPermissions(anIdPublication, aUser)
		publicationDAO.agregarNoMeGustaPublicacion(anIdPublication, aUser)
		publicationDAO.quitarMeGustaPublicacion(   anIdPublication, aUser)
	}
	
	def publicitarComentario(String anIdPublication, Comentary aComentary) {
		
		aComentary.id = UUID.randomUUID
		publicationDAO.addComment(anIdPublication, aComentary)
	}

	override meGusta(String aUser, UUID idCommentary) {

//		var strategy = new MeGustaComnentary
//		rateComment(aUser, idCommentary, strategy)	
		verifyPermissions(idCommentary, aUser)
		publicationDAO.agregarMeGustaComentario( idCommentary, aUser)
		publicationDAO.quitarNoMeGustaComentario(idCommentary, aUser)
	}
	
	def havePermissions(UUID idCommentary, String aUser) {
		var amigos = amigos(aUser)
		publicationDAO.tienePermisosParaInteractuarConElComentario(idCommentary, aUser, amigos)
	}
	// Sacar if y logica repetida
	def verifyPermissions(UUID idCommentary, String aUser){
		if(!havePermissions(idCommentary, aUser)){
			throw new ExceptionNoTienePermisoParaInteractuarConElComentario("El usuario no tiene permiso para interactuar con el comentario")
		}
	}
	// Sacar if y logica repetida
	def verifyPermissions(String idPublication, String aUser){
		if(!havePermissions(idPublication, aUser)){
			throw new ExceptionNoTienePermisoParaInteractuarConLaPublicacion("El usuario no tiene permiso para interactuar con la publicacion")
		}
	}
	
	override noMeGusta(String aUser, UUID idCommentary) {
		
//		var strategy = new NoMeGustaComnentary
//		rateComment(aUser, idCommentary, strategy)
		verifyPermissions(idCommentary, aUser)
		publicationDAO.agregarNoMeGustaComentario(idCommentary, aUser)
		publicationDAO.quitarMeGustaComentario(   idCommentary, aUser)
	}
	
	def save(Publication publication) {
		publicationDAO.save(publication)
	}
	
	override verPerfil(String aUserName, String author) {
		
		var amigos = amigos(aUserName)
	
		var aProfile = new Profile  
		aProfile.publications =	publicationDAO.loadProfile(aUserName, author, amigos)
			
		aProfile
	}
	
//	def rateComment(String aUser, UUID idCommentary, PublicationOfCommentary strategyOfCommentary){
//		
//		var aPublication   = publicationDAO.loadForCommentary(idCommentary)
//		val aCommentary    = aPublication.searchCommentary(idCommentary)
//  		
// 		strategyOfCommentary.initialize(aPublication, aUser, aCommentary, this)
//		
//		aPrivacyHandler.permitPublicationAccess(aCommentary, strategyOfCommentary, aUser) 
//	}
//	
//	def publicitarNota(String anIdPublication, PublicationOfNote command, String aUser){
//		
//		val unaPublicacion = load(anIdPublication) 
//		
//		command.publication = unaPublicacion
//		 
//		aPrivacyHandler.permitPublicationAccess(unaPublicacion, command, aUser) 
//	}
//	
//	def load(String idPublication) {
//		publicationDAO.loadWithOnlyTheVisibilityAndTheAuthor(idPublication)
//	}
//	



	
}




