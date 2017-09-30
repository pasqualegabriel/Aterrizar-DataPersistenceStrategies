package busquedaService

import aereolinea.Asiento
import java.util.List
import service.User
import Busqueda.Busqueda

interface BusquedaService {
	
	def List<Asiento> buscar(Busqueda busqueda, User usuario)
	
	def List<BusquedaHibernate> list(User usuario)
	
	def List<Asiento> busquedasGuardada(Busqueda busqueda, User usuario)
	
}