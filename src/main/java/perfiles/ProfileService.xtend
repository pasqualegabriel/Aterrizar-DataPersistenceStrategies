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
	
	def visitoDestino(Publication aPublication) {
		Runner.runInSession [
			hibernateUserDAO.visito(aPublication.author, aPublication.destino.id) 
		]
	}

	override agregarComentario(String anIdPublication, Comentary aComentary) {

		verifyPermissionsForPublication(anIdPublication, aComentary.author)
		publicitarComentario(anIdPublication, aComentary)
	
		aComentary
	}

	override meGusta(String aUser, String anIdPublication) {
		
		verifyPermissionsForPublication(anIdPublication, aUser)
		publicationDAO.agregarMeGustaPublicacion( anIdPublication, aUser)
		publicationDAO.quitarNoMeGustaPublicacion( anIdPublication, aUser)
	}
	
	
	
	def amigos(String aUser) {
		relacionesDeAmistades.userNames(aUser)
	}

	override noMeGusta(String aUser, String anIdPublication) {
		
		verifyPermissionsForPublication(anIdPublication, aUser)
		publicationDAO.agregarNoMeGustaPublicacion(anIdPublication, aUser)
		publicationDAO.quitarMeGustaPublicacion(   anIdPublication, aUser)
	}
	
	def publicitarComentario(String anIdPublication, Comentary aComentary) {
		
		aComentary.id = UUID.randomUUID
		publicationDAO.addComment(anIdPublication, aComentary)
	}

	override meGusta(String aUser, UUID idCommentary) {

		verifyPermissionsForCommentary(idCommentary, aUser)
		publicationDAO.agregarMeGustaComentario( idCommentary, aUser)
		publicationDAO.quitarNoMeGustaComentario(idCommentary, aUser)
	}
	
	
	def hasPermissionToInteractWithPublication(String anIdPublication, String aUser) {
		var amigos = amigos(aUser)
		publicationDAO.tienePermisosParaInteractuarConLaPublicacion(anIdPublication, aUser, amigos)
	}
	
	
	def hasPermissionToInteractWithCommentary(UUID idCommentary, String aUser) {
		var amigos = amigos(aUser)
		publicationDAO.tienePermisosParaInteractuarConElComentario(idCommentary, aUser, amigos)
	}
	

	def verifyPermissionsForCommentary(UUID idCommentary, String aUser){
		if(!hasPermissionToInteractWithCommentary(idCommentary, aUser)){
			throw new ExceptionNoTienePermisoParaInteractuarConElComentario("El usuario no tiene permiso para interactuar con el comentario")
		}
	}
	
	
	def verifyPermissionsForPublication(String idPublication, String aUser){
		if(!hasPermissionToInteractWithPublication(idPublication, aUser)){
			throw new ExceptionNoTienePermisoParaInteractuarConLaPublicacion("El usuario no tiene permiso para interactuar con la publicacion")
		}
	}
	
	
	override noMeGusta(String aUser, UUID idCommentary) {
		
		verifyPermissionsForCommentary(idCommentary, aUser)
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
	



	
}




