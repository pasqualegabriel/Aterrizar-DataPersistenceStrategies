package daoImplementacion

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import runner.Runner
import org.junit.After
import asientoServicio.Compra
import dao.CompraDAO
import service.User
import aereolinea.Asiento
import java.util.List

class TestDAOCompra {
	Compra 			compraDoc
	CompraDAO		compraDAOSuj
	User			usuarioDOC
	List<Asiento>	asientos
	
	@Before
	def void setUp(){
		asientos =newArrayList
		asientos.add(new Asiento)
		usuarioDOC      = new User
		usuarioDOC.name = "Pepita"
		compraDoc		= new Compra(asientos,usuarioDOC)
		compraDAOSuj	= new HibernateCompraDAO
		
	}
	
	@Test
	def void testHacerUnSaveYLuegoUnLoadSeObtieneMismoObjetosEnLaMismaSession(){
		
	
		Runner.runInSession[ {
			compraDAOSuj.save(compraDoc)
			var otherPurchase = compraDAOSuj.load(compraDoc)
			assertEquals(compraDoc.asientos,otherPurchase.asientos)
			assertEquals(compraDoc.asientos.size,otherPurchase.asientos.size)
			assertEquals(compraDoc.comprador,otherPurchase.comprador)
			assertEquals(compraDoc.comprador.name,otherPurchase.comprador.name)
			assertEquals(compraDoc,otherPurchase)
			null
		}]
	}
	@Test
	def void testAlHacerUnSaveYCerrarLaSeccionCuandoAbrimosUnaNuevaYHacemosLoadLasIntanciasDelObjetoSonDiferentes(){
			
		Runner.runInSession[ {
	
			compraDAOSuj.save(compraDoc)
			null
		}]
	
	
		Runner.runInSession[ {
			var otherPurchase = compraDAOSuj.load(compraDoc)
			assertNotEquals(compraDoc.asientos,otherPurchase.asientos)
			assertEquals(compraDoc.asientos.size,otherPurchase.asientos.size)
			assertNotEquals(compraDoc.comprador,otherPurchase.comprador)
			assertEquals(compraDoc.comprador.name,otherPurchase.comprador.name)
			assertNotEquals(compraDoc,otherPurchase)
			null
		}]
	}
	
	@Test
	def void testAlHacerUnSaverYUpdatearAUnUsuarioSeVerificaQueSePersistieronLosCambios() {
	
		Runner.runInSession[ {

			/**asserts antes de guardar la reserva */
			assertEquals(1,compraDoc.asientos.size)
			assertEquals("Pepita",compraDoc.comprador.name)
			compraDAOSuj.save(compraDoc)
			/**-------------------------------------------- */
			/** Modifico A la reserva para el update */
			asientos.add(new Asiento)
			var userDoc2 		= new  User()
			userDoc2.name		= "Peron"
			compraDoc.comprador	= userDoc2
			compraDoc.asientos	= asientos
			

			compraDAOSuj.update(compraDoc)
			/**-------------------------------------------- */
			/**asserts despues de hacer el update y volver a traer a la reserva */
			var otherReservation = compraDAOSuj.load(compraDoc)
			assertEquals(2,otherReservation.asientos.size)
			assertEquals("Peron",otherReservation.comprador.name)
			null
		}]
		
	}
	
	
	
	
	
	@After
	def void tearDown(){
		compraDAOSuj.clearAll
	}
}