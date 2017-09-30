package dao

import asientoServicio.Reserva

interface ReservaDAO {
	def void save(Reserva aReservation)

	def Reserva load(Reserva aReservation)

	def void update(Reserva aReservation)
	
	def void clearAll()
}