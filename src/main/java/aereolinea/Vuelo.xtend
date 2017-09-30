package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

@Accessors
class Vuelo {
	List<Tramo> tramos = newArrayList

	Aereolinea aerolinea
	
	new(Aereolinea unaAerolinea){
		aerolinea= unaAerolinea
	}
}