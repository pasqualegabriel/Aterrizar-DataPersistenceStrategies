package perfiles

// Responsabilidad: Se hace cargo de Proveer el acceso adecuado para la publicacion y el usuario que accede.

class PrivacyHandler {
	
	
	new(){		}
	
	def permitPublicationAccess(Nota aNote,PublicationOfNote strategy, String aUser){
		
		#[new OnlyFriendsAcess, new PublicAcess, new PrivateAcess, new AcessDenied].findFirst[it.canHandleVisibility(aNote.visibilidad,aNote.author, aUser)].permitAcces(strategy)
	}
	
	
//	def permitViewAccess(String author ,PublicationOfNote strategy, String aUser){
//		
//		#[new OnlyFriendsAcess, new PublicAcess, new PrivateAcess].findFirst[it.canHandle(author, aUser)].permitView(strategy)
//	
//	}
	
	
	
	
}