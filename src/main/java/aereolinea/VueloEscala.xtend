package aereolinea
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

@Accessors
class VueloEscala extends Vuelo {
	List<Tramo> tramos = newArrayList
}