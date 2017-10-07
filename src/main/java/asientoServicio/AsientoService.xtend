package asientoServicio

import service.User
import java.util.List
import aereolinea.Asiento
import aereolinea.Tramo

interface AsientoService {
	
	def Reserva reservar(Integer unAsiento, String unUser)
	
	def Reserva reservarAsientos(List<Integer> unosAsientos, String unUsuario)
	
	def Compra comprar( Integer unaReserva, String unUsuario)

	def List<Compra>  compras(String unUsuario)

	def List<Asiento> disponibles(Integer unTramo)	
}