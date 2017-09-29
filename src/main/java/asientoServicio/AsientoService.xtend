package asientoServicio

import service.User
import java.util.List
import aereolinea.Asiento
import aereolinea.Tramo

interface AsientoService {
	
	def Reserva reservar(Asiento unAsiento, User unUser)
	
	def Reserva reservarAsientos(List<Asiento> unosAsientos, User unUsuario)
	
	def Compra comprar( Reserva unaReserva, User unUsuario)

	def List<Compra>  compras(User unUsuario)

	def List<Asiento> disponibles(Tramo unTramo)	
}