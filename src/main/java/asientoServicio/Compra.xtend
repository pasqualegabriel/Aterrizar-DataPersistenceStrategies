package asientoServicio

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import aereolinea.Asiento

@Accessors
class Compra {
	List<Asiento> asientos
	
	new(List<Asiento> unosAsientos) {
		asientos=unosAsientos
	}
	
}