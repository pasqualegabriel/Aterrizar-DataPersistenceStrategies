package dao

import asientoServicio.Reserva

interface ReservaDAO {
	
	def void save(Reserva unaReserva)

	def Reserva load(Integer unaReserva)
	
	def void update(Reserva unaReserva)
	
}