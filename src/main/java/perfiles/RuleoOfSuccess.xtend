package perfiles

import java.util.List

//Responsabilidad: Container de RulesOfPermition

class RuleoOfSuccess extends AccessPermited  {
	
	List<AccessPermited> rulesOfPermition = newArrayList
	
	new (){
		rulesOfPermition= #[new PrivateAcess, new PublicAcess, new OnlyFriendsAcess]
		
	}
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
		rulesOfPermition.stream.anyMatch[it.canHandle(visibilidad,author,anUserName)]
	}
	
	
	
}