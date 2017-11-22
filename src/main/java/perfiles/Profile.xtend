package perfiles

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Profile {
	
	List<Publication> publications = newArrayList
	
	new(){
		super()
	}
	
}