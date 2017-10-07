package dao

import aereolinea.Asiento
import java.util.List

interface AsientoDAO {
	
	def void save(Asiento unAsiento)

	def Asiento load(Integer unAsiento)
	
	def void update(Asiento unAsiento)
	
	def List<Asiento> loadAsientos(List<Integer> integers)
	
}