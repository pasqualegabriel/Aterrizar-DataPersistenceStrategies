package dao

import Busqueda.Busqueda
import java.util.List
import aereolinea.Asiento

interface BusquedaDAO {
	
	def void save(Busqueda aSearch)

	def Busqueda load(Busqueda aSearch)
	
	def Busqueda loadById(Integer busqueda)
	
	def void clearAll()
	
	def List<Asiento> buscarAsientosDisponibles(Busqueda busqueda)
	
	def List<Busqueda> ultimasDiezBusquedasRealizadas(String string)
		
}