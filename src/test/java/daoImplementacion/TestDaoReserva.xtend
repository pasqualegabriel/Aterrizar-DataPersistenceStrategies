package daoImplementacion

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import runner.Runner

import asientoServicio.Reserva

import org.junit.After
import service.User
import dao.UserDAO
import java.util.Date
import aereolinea.Asiento
import service.TruncateTables

class TestDaoReserva {
	
	Reserva 	reservaDoc	
	UserDAO 	userDAOSuj
	User    	userDoc
	
	@Before
	def void setUp(){
		
		reservaDoc			  = new Reserva
		userDAOSuj  		  = new HibernateUserDAO
		userDoc 		 	  = new User("Loca","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date())
		userDoc.reserva		  = reservaDoc
	}
	
	
	@Test
	def void testAlHacerUnSaveYLuegoRecuperarSeObtieneMismoObjetosEnLaMismaSession(){
		
	
		Runner.runInSession[
	
			userDAOSuj.save(userDoc)
			var otherUser = userDAOSuj.load(userDoc)
			assertEquals(userDoc.reserva.asientos,otherUser.reserva.asientos)
			assertEquals(userDoc.reserva.asientos.size,otherUser.reserva.asientos.size)
			assertEquals(userDoc.reserva.horaRealizada,otherUser.reserva.horaRealizada)
			assertEquals(userDoc.reserva.estaValidado,otherUser.reserva.estaValidado)
			assertEquals(userDoc.reserva,otherUser.reserva)

			null
		]
	}
	@Test
	def void testAlHacerUnSaveYCerrarLaSeccionCuandoAbrimosUnaNuevaYHacemosLoadLasIntanciasSonDiferentes(){
			
		Runner.runInSession[ 
	
			userDAOSuj.save(userDoc)
			null
		]
	
	
		Runner.runInSession[
			var otherUser = userDAOSuj.load(userDoc)
			assertNotEquals(userDoc.reserva.asientos,otherUser.reserva.asientos)
			assertEquals(userDoc.reserva.asientos.size,otherUser.reserva.asientos.size)
			assertEquals(userDoc.reserva.estaValidado,otherUser.reserva.estaValidado)
			assertNotEquals(userDoc.reserva,otherUser.reserva)
			null
		]
	}
	
	@Test
	def void testAlHacerUnSaverYUpdatearAUnUsuarioSeVerificaQueSePersistieronLosCambios() {
	
		Runner.runInSession[

			/**asserts antes de guardar la reserva */
			assertEquals(0,userDoc.reserva.asientos.size)
			assertTrue(userDoc.reserva.estaValidado)	
			userDAOSuj.save(userDoc)
			
			/** Modifico A la reserva para el update */
			var asientos =newArrayList
			asientos.add(new Asiento)
			reservaDoc.asignarleAsientos(asientos)
			reservaDoc.invalidar
			userDAOSuj.update(userDoc)
			var otherUser = userDAOSuj.load(userDoc)
			
			/**asserts despues de hacer el update y volver a traer a la reserva */
			assertEquals(1,otherUser.reserva.asientos.size)
			assertFalse(otherUser.reserva.estaValidado)
			
			null
		]
		
	}
	
	
	
	@After
	def void tearDown(){

		new TruncateTables => [ vaciarTablas ]

	}
}