package perfiles

import java.util.List

class PrivacyHandler {
	
	List<AccessOfPrivacy> accesOfPrivacy = newArrayList
	
	new(){
		accesOfPrivacy = # [new PrivateAcess, new PublicAcess, new OnlyFriendsAcess, new AcessDenied]
	}
	
	def hasPermission(Nota publicacion,StrategyOfPublication strategy, String author){
		accesOfPrivacy.findFirst[it.canHandle(publicacion.visibilidad,publicacion.author, author)].assertRule(strategy)
	}
	
}