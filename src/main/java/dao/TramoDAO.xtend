package dao

import aereolinea.Tramo

interface TramoDAO {

	
	def void save(Tramo unTramo)

	def Tramo load(Integer unTramo)
	
}