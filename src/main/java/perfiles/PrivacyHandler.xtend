package perfiles

import java.util.List

class PrivacyHandler {
	
	List<AccessOfPrivacy> accesOfPrivacy = newArrayList
	
	new(){
		accesOfPrivacy = #[new PrivateAcess, new PublicAcess, new OnlyFriendsAcess, new AcessDenied]
	}
	
	def hasPermission(Nota aNote,StrategyOfNote strategy, String aUser){
		accesOfPrivacy.findFirst[it.canHandle(aNote.visibilidad,aNote.author, aUser)].assertRule(strategy)
	}
	
	//Pensar nombre o buscar mejor abstraccion.
	def xy(Nota aNote, String aUser) {
		#[new PrivateAcess, new PublicAcess, new OnlyFriendsAcess].stream.anyMatch[it.canHandle(aNote.visibilidad, aNote.author,aUser)]
	}
	
}