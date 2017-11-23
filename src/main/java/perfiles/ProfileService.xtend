package perfiles


import daoImplementacion.HibernateUserDAO
import daoImplementacion.PublicationDAO
import runner.Runner
import java.util.UUID


class ProfileService implements PerfilService{
	
	HibernateUserDAO 	hibernateUserDAO
	PublicationDAO		publicationDAO
	
	new(PublicationDAO aPublicationDAO, HibernateUserDAO aHibernateUserDAO) {
		this.hibernateUserDAO	= aHibernateUserDAO
		this.publicationDAO		= aPublicationDAO
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
	
//	def pepe (String anIdPublication,StrategyOfPublication command  )
//	{
//		val unaPublicacion = publicationDAO.load(anIdPublication) 
//		
//		command.setParameters() 
//		
//		new PrivacyHandler => [ hasPermission(unaPublicacion, strategy, aUser) ]
//		
//	}
	
	// Generar abstraccion, logica repetida!!!! 
	override agregarComentario(String anIdPublication, Comentary aComentary) {
		
		val unaPublicacion = publicationDAO.load(anIdPublication) 
		
		val strategy       = new CommentaryStrategy(aComentary, unaPublicacion, this) 
		new PrivacyHandler => [ hasPermission(unaPublicacion, strategy, aComentary.author) ]
	
		aComentary
	}

	override meGusta(String aUser, String anIdPublication) {
			
		val unaPublicacion = publicationDAO.load(anIdPublication) 
		
		val strategy       = new MeGustaPublication(unaPublicacion, aUser, this) 
		new PrivacyHandler => [ hasPermission(unaPublicacion, strategy, aUser) ]
	}

	override noMeGusta(String aUser, String anIdPublication) {

		val unaPublicacion = publicationDAO.load(anIdPublication) 
		
		val strategy       = new NoMeGustaPublication(unaPublicacion, aUser, this) 
		new PrivacyHandler => [ hasPermission(unaPublicacion, strategy, aUser) ]
	}
	
	
	
	override verPerfil(String aUser, String otherUser) {

		var aProfile = new Profile =>  [ publications=	publicationDAO.loadAllPublications(otherUser) ]
		filtrarPublicacionesPermitidas(aProfile, aUser)
		filtrarComentariosEnPublicaciones(aProfile, aUser)
		
		aProfile
	}
	
	def void filtrarPublicacionesPermitidas(Profile aProfile, String aUser) {
		
		val aPrivacyHandler      = new PrivacyHandler 
		val filteredPublications = aProfile.publications.filter[aPublication| aPrivacyHandler.xy(aPublication, aUser)].toList
		aProfile.publications    = filteredPublications
	}
	
	def filtrarComentariosEnPublicaciones(Profile aProfile, String aUser) {

		aProfile.publications.forEach[aPublication| filtrarComentariosPermitidos(aPublication, aUser)]
	}
	
	def filtrarComentariosPermitidos(Publication publication, String aUser) {
		
		val aPrivacyHandler     = new PrivacyHandler 
		var filteredComentaries = publication.comentarios.filter[aComentary | aPrivacyHandler.xy(aComentary, aUser)].toList
		publication.comentarios = filteredComentaries
	}

	def publicitarComentario(Publication publication, Comentary aComentary) {
		
		aComentary.id =  UUID.randomUUID
		publication.agregarComentario(aComentary)
		
		publicationDAO.update(publication)
	}

	def update(Publication publication){
		publicationDAO.update(publication)
	}

	// Generar abstraccion, logica repetida!!!! 
	override meGusta(String aUser, UUID idCommentary) {

		var strategy = new MeGustaComnentary
		rateComment(aUser, idCommentary, strategy)	
		
//		var aPublication	= publicationDAO.loadForCommentary(idCommentary)
//		val aCommentary  	= aPublication.searchCommentary(idCommentary)
//		
//		val strategy     	= new MeGustaComnentary(aPublication, aUser, aCommentary, this)  
//		new PrivacyHandler 	=> [ hasPermission(aCommentary, strategy, aUser) ]
	}
	
	override noMeGusta(String aUser, UUID idCommentary) {
		
		
		
		var strategy = new NoMeGustaComnentary
		rateComment(aUser, idCommentary, strategy)
		
//		var aPublication   = publicationDAO.loadForCommentary(idCommentary)
//		val aCommentary    = aPublication.searchCommentary(idCommentary)
//		
//		val strategy       = new NoMeGustaComnentary(aPublication, aUser, aCommentary, this)  
//		new PrivacyHandler => [ hasPermission(aCommentary, strategy, aUser) ]
	}
	
	def rateComment(String aUser, UUID idCommentary, StrategyOfCommentary strategyOfCommentary){
		
		var aPublication   = publicationDAO.loadForCommentary(idCommentary)
		val aCommentary    = aPublication.searchCommentary(idCommentary)
  		
  		//Cambiar el nombre a command.
		strategyOfCommentary.initialize(aPublication, aUser, aCommentary, this)
		
		new PrivacyHandler => [ hasPermission(aCommentary, strategyOfCommentary, aUser) ]
	}
	
	def save(Publication publication) {
		publicationDAO.save(publication)
	}


	
}




