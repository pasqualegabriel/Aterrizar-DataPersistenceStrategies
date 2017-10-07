package busquedaService

import aereolinea.Asiento
import java.util.List
import service.User
import Busqueda.Busqueda

interface BusquedaService {
	
	def List<Asiento> buscar(Busqueda busqueda, String usuario)
	
	def List<Busqueda> list(String usuario)
	
	def List<Asiento> busquedasGuardada(Integer busqueda, String usuario)
	
}