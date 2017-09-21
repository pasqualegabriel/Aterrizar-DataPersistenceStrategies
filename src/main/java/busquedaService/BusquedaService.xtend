package busquedaService

import aereolinea.Asiento
import java.util.List
import service.User

interface BusquedaService {
	
	def List<Asiento> buscar(Busqueda busqueda, User usuario)
	
	def List<Busqueda> list(User usuario)
	
	def List<Asiento> busquedasGuardada(Busqueda busqueda, User usuario)
	
}