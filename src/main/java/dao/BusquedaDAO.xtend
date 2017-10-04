package dao

import Busqueda.Busqueda

interface BusquedaDAO {
	def void save(Busqueda aSearch)

	def Busqueda load(Busqueda aSearch)
	
	def void clearAll()
		
}