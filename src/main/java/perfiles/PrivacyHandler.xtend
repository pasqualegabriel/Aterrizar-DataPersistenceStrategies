package perfiles

import java.util.List

class PrivacyHandler {
	
	
	AccessPermited accesPermited
	AcessDenied	   accesDenied
	
	List<AccessOfPrivacy> accesOfPrivacy = newArrayList
	
	new(){
		accesPermited = new RuleoOfSuccess
		accesDenied   = new AcessDenied
		accesOfPrivacy = #[accesPermited,accesDenied]
		
	}
	
	def permitAccess(Nota aNote,PublicationOfNote strategy, String aUser){
		accesOfPrivacy.findFirst[it.canHandle(aNote.visibilidad,aNote.author, aUser)].assertRule(strategy)
	}
	
	def hasPermition(Nota aNote, String aUser) {
		accesPermited.canHandle(aNote.visibilidad, aNote.author,aUser)
	}
	
}