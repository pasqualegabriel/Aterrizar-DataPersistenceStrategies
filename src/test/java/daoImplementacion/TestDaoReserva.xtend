package daoImplementacion

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import runner.Runner

import asientoServicio.Reserva
import dao.ReservaDAO
import org.junit.After

class TestDaoReserva {
	Reserva 	reservaSuj
	ReservaDAO 	reservaDAODoc
	
	@Before
	def void setUp(){
		reservaSuj		= new Reserva()
		reservaDAODoc	= new HibernateReservaDAO
	}
	
	@Test
	def void testAlGuardarYLuegoRecuperarSeObtieneMismoObjetos(){
		
	
		Runner.runInSession[ {
	
			reservaDAODoc.save(reservaSuj)
			var otherReservation = reservaDAODoc.load(reservaSuj)
			assertEquals(reservaSuj.asientos,otherReservation.asientos)
			assertEquals(reservaSuj,otherReservation)
			null
		}]
	}
	@After
	def void tearDown(){
		reservaDAODoc.clearAll
	}
}