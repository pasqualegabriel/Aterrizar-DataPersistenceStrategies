package perfiles

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class AccessPermited extends AccessOfPrivacy{
	
	// esta es la abstracta
	//ruleofsucces Componedor
	//los otros , pirvate acces, public acces, onlyfriends es el leaf.
	//el private handler inicia al componedor con las 3 leafs, y despues es todo igual.
	
	// hay que revisar los commands y rehacerlos prolijos
	// hay que cambiar los nombres que quedaron flojos y sacar las cosas comentadas
	// hay que hacer bien los filtros.
	List<AccessPermited> rulesOfPermition = newArrayList
	
	new (){
		rulesOfPermition= #[new PrivateAcess, new PublicAcess, new OnlyFriendsAcess]
		
	}
	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) {
		rulesOfPermition.stream.anyMatch[it.canHandle(visibilidad,author,anUserName)]
	}
	
	
	
}