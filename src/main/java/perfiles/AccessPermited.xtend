package perfiles

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class AccessPermited extends AccessOfPrivacy{
	
	List<AccessPermited> rulesOfPermition = newArrayList
	
	new (){
		rulesOfPermition= #[new PrivateAcess, new PublicAcess, new OnlyFriendsAcess]
		
	}
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
		rulesOfPermition.stream.anyMatch[it.canHandle(visibilidad,author,anUserName)]
	}
	
	
	
}