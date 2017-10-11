package dao

import Busqueda.Busqueda

interface BusquedaDAO {
	
	def void save(Busqueda aSearch)

	def Busqueda load(Busqueda aSearch)
	
	def Busqueda loadById(Integer busqueda)
	
	def void clearAll()
		
}