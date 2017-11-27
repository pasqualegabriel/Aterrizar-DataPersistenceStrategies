package perfiles


import daoImplementacion.HibernateUserDAO
import daoImplementacion.PublicationDAO
import runner.Runner
import java.util.UUID
import unq.amistad.RelacionesDeAmistades

class ProfileService implements PerfilService{
	
	HibernateUserDAO 	  hibernateUserDAO
	PublicationDAO		  publicationDAO
    PrivacyHandler        aPrivacyHandler
    RelacionesDeAmistades relacionesDeAmistades
	
	new(PublicationDAO aPublicationDAO, HibernateUserDAO aHibernateUserDAO) {
		this.hibernateUserDAO	   = aHibernateUserDAO
		this.publicationDAO		   = aPublicationDAO
		this.aPrivacyHandler       = new PrivacyHandler
        this.relacionesDeAmistades = new RelacionesDeAmistades
	}
	
	override agregarPublicación(String aUser, Publication aPublication) {
		
		var newPublication = new NewPublication 
		newPublication.canPublish(aUser, aPublication, this)
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
		
		val command       = new PublicationOfCommentary(aComentary, this) 
		publicitarNota (anIdPublication,command,aComentary.author  )
	
		aComentary
	}

	override meGusta(String aUser, String anIdPublication) {
		
		val command       = new MeGustaPublication(aUser, this) 
		publicitarNota (anIdPublication,command,aUser )
		
	}

	override noMeGusta(String aUser, String anIdPublication) {
		
		val command       = new NoMeGustaPublication(aUser, this) 
		publicitarNota (anIdPublication,command,aUser  )
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

		var strategy = new MeGustaComnentary
		rateComment(aUser, idCommentary, strategy)	
	
	}
	
	override noMeGusta(String aUser, UUID idCommentary) {
		
		var strategy = new NoMeGustaComnentary
		rateComment(aUser, idCommentary, strategy)
	}
	

	
//	override verPerfil(String aUser, String otherUser) {
//
//		var aProfile = new Profile =>  [ publications=	publicationDAO.loadAllPublications(otherUser) ]
//		filtrarPublicacionesPermitidas(aProfile, aUser)
//		filtrarComentariosEnPublicaciones(aProfile, aUser)
//		
//		aProfile
//	}
//	
//	def void filtrarPublicacionesPermitidas(Profile aProfile, String aUser) {
//		
//		
//		
//		val filteredPublications = aProfile.publications.filter[aPublication| aPrivacyHandler.hasPermition(aPublication, aUser)].toList
//		aProfile.publications    = filteredPublications
//	}
//	
//	
//	def filtrarComentariosEnPublicaciones(Profile aProfile, String aUser) {
//
//		aProfile.publications.forEach[aPublication| filtrarComentariosPermitidos(aPublication, aUser)]
//	}
//	
//	def filtrarComentariosPermitidos(Publication publication, String aUser) {
//	
//		
//		var filteredComentaries = publication.comentarios.filter[aComentary | aPrivacyHandler.hasPermition(aComentary, aUser)].toList
//		publication.comentarios = filteredComentaries
//	}
	
	
	
	
	
	
	def rateComment(String aUser, UUID idCommentary, PublicationOfCommentary strategyOfCommentary){
		
		var aPublication   = publicationDAO.loadForCommentary(idCommentary)
		val aCommentary    = aPublication.searchCommentary(idCommentary)
  		
 		strategyOfCommentary.initialize(aPublication, aUser, aCommentary, this)
		
	
		aPrivacyHandler.permitPublicationAccess(aCommentary, strategyOfCommentary, aUser) 
	}
	
	
	def publicitarNota(String anIdPublication, PublicationOfNote command, String aUser){
		val unaPublicacion = publicationDAO.load(anIdPublication) 
		
		command.publication = unaPublicacion
		 
		aPrivacyHandler.permitPublicationAccess(unaPublicacion, command, aUser) 
	}
	
	def save(Publication publication) {
		publicationDAO.save(publication)
	}
	
	override verPerfil(String aUserName, String author) {
		
		var amigos = relacionesDeAmistades.userNames(aUserName)
	
		var aProfile = new Profile  
		aProfile.publications =	publicationDAO.loadProfile(aUserName, author, amigos)
			
		aProfile
	}


	
}




