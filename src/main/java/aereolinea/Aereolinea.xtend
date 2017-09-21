package aereolinea

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Aereolinea {
	String nombre
	List<Vuelo> vuelosOfertados = newArrayList
}