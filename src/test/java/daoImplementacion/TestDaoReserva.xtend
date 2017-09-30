package daoImplementacion

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import runner.Runner

import asientoServicio.Reserva
import dao.ReservaDAO
import org.junit.After
import aereolinea.Asiento


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
			assertEquals(reservaSuj.horaRealizada,otherReservation.horaRealizada)
			assertEquals(reservaSuj.estaValidado,otherReservation.estaValidado)
			assertEquals(reservaSuj,otherReservation)
			null
		}]
	}
	@Test
	def void testAlHacerUnSaveYCerrarLaSeccionCuandoAbrimosUnaNuevaYHacemosLoadLasIntanciasSonDiferentes(){
			
		Runner.runInSession[ {
	
			reservaDAODoc.save(reservaSuj)
			null
		}]
	
	
		Runner.runInSession[ {
			var otherReservation = reservaDAODoc.load(reservaSuj)
			assertNotEquals(reservaSuj.asientos,otherReservation.asientos)
			assertEquals(reservaSuj.asientos.size,otherReservation.asientos.size)
			//assertEquals(reservaSuj.horaRealizada,otherReservation.horaRealizada)
			assertEquals(reservaSuj.estaValidado,otherReservation.estaValidado)
			assertNotEquals(reservaSuj,otherReservation)
			null
		}]
	}
	
	@Test
	def void testAlHacerUnSaverYUpdatearAUnUsuarioSeVerificaQueSePersistieronLosCambios() {
	
		Runner.runInSession[ {

			/**asserts antes de guardar la reserva */
			assertEquals(0,reservaSuj.asientos.size)
			assertTrue(reservaSuj.estaValidado)	
			reservaDAODoc.save(reservaSuj)
			
			/** Modifico A la reserva para el update */
			var asientos =newArrayList
			asientos.add(new Asiento)
			reservaSuj.asignarleAsientos(asientos)
			reservaSuj.invalidar
			reservaDAODoc.update(reservaSuj)
			var otherReservation = reservaDAODoc.load(reservaSuj)
			
			/**asserts despues de hacer el update y volver a traer a la reserva */
			assertEquals(1,otherReservation.asientos.size)
			assertFalse(otherReservation.estaValidado)
			
			null
		}]
		
	}
	
	
	
	@After
	def void tearDown(){
		reservaDAODoc.clearAll
	}
}