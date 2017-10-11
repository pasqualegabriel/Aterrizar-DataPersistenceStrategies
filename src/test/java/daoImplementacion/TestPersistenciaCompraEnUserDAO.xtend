package daoImplementacion

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import runner.Runner
import org.junit.After
import asientoServicio.Compra

import service.User
import aereolinea.Asiento
import java.util.List
import asientoServicio.Reserva
import dao.UserDAO
import java.util.Date
import aereolinea.Tramo
import service.TruncateTables

class TestPersistenciaCompraEnUserDAO {
	Compra 			compraDoc
	List<Asiento>	asientos
	Reserva 	    reservaDoc	
	UserDAO 	    userDAOSuj
	User    	    userDoc
	
	@Before
	def void setUp(){
		asientos 				= newArrayList
		asientos.add(new Asiento)
		userDAOSuj  		  	= new HibernateUserDAO
		userDoc 		 	  	= new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date())
		compraDoc				= new Compra(asientos,userDoc, new Tramo)
		reservaDoc			  	= new Reserva

		userDoc.reserva		  	= reservaDoc

		
	}
	@Test
	def void testHacerUnSaveYLuegoUnLoadSeObtieneMismoObjetosEnLaMismaSession(){
		
	
		Runner.runInSession[
			assertEquals(0,userDoc.compras.size)
			userDoc.agregarCompra(compraDoc)
			userDAOSuj.save(userDoc)
			
			var otherUser = userDAOSuj.load(userDoc)
			assertEquals(1,otherUser.compras.size)
			assertEquals(userDoc.compras.size,otherUser.compras.size)
			assertEquals(userDoc.compras.stream.anyMatch[it.asientos.size.equals(1)], otherUser.compras.stream.anyMatch[it.asientos.size.equals(1)])
			
			

			assertEquals(userDoc.compras.stream.anyMatch[it.comprador.equals(userDoc)],otherUser.compras.stream.anyMatch[it.comprador.equals(userDoc)])
			
			assertEquals(userDoc.compras.stream.anyMatch[it.comprador.equals(userDoc.name)],otherUser.compras.stream.anyMatch[it.comprador.equals(userDoc.name)])
			assertEquals(userDoc.compras,otherUser.compras)
			null
		]
	}
	
	@Test
	def void testAlHacerUnSaveYCerrarLaSeccionCuandoAbrimosUnaNuevaYHacemosLoadLasIntanciasDelObjetoSonDiferentes(){
			
		Runner.runInSession[
			assertEquals(0,userDoc.compras.size)
			userDoc.agregarCompra(compraDoc)
			userDAOSuj.save(userDoc)
			null
		]
	
	
		Runner.runInSession[
			var otherUser = userDAOSuj.load(userDoc)
			
			assertEquals(1,otherUser.compras.size)
			assertEquals(userDoc.compras.size,otherUser.compras.size)
			assertEquals(userDoc.compras.stream.anyMatch[it.asientos.size.equals(1)], otherUser.compras.stream.anyMatch[it.asientos.size.equals(1)])
			assertNotEquals(userDoc.compras.stream.anyMatch[it.comprador.equals(userDoc)],otherUser.compras.stream.anyMatch[it.comprador.equals(userDoc)])
			assertEquals(userDoc.compras.stream.anyMatch[it.comprador.equals(userDoc.name)],otherUser.compras.stream.anyMatch[it.comprador.equals(userDoc.name)])
			assertNotEquals(userDoc.compras,otherUser.compras)
			
			null
		]
	}
	
	@Test
	def void testAlHacerUnSaverYUpdatearAUnUsuarioSeVerificaQueSePersistieronLosCambios() {
	
		Runner.runInSession[

			/**asserts antes de guardar la reserva */
			userDoc.agregarCompra(compraDoc)
			assertTrue(userDoc.compras.stream.anyMatch[it.asientos.size.equals(1)])		
			userDAOSuj.save(userDoc)
			/**-------------------------------------------- */
			/** Modifico A la reserva para el update */
			asientos.add(new Asiento)
			userDAOSuj.update(userDoc)
			/**-------------------------------------------- */
			/**asserts despues de hacer el update y volver a traer a la reserva */
			var otherUser = userDAOSuj.load(userDoc)
			assertTrue(otherUser.compras.stream.anyMatch[it.asientos.size.equals(2)])

			null
		]
		
	}
	
	@After
	def void tearDown(){

		new TruncateTables => [ vaciarTablas ]

	}
	
	
	
	
}





