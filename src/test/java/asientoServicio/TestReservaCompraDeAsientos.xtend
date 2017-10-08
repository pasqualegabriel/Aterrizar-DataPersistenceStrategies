package asientoServicio

import org.junit.Before
import static org.junit.Assert.*
import org.junit.Test
import service.User
import java.util.List
import Excepciones.ExepcionCompra
import Excepciones.ExepcionReserva
import categorias.Turista
import aereolinea.Asiento
import aereolinea.Tramo
import categorias.Business
import categorias.Primera
import aereolinea.Vuelo
import aereolinea.Aereolinea
import aereolinea.Destino
import java.time.LocalDateTime
import daoImplementacion.HibernateUserDAO
import org.junit.After
import java.util.Date
import runner.Runner
import daoImplementacion.HibernateAsientoDAO
import daoImplementacion.HibernateReservaDAO
import daoImplementacion.HibernateTramoDAO

class TestReservaCompraDeAsientos {
	
	AsientoService 			testReservaCompraDeAsientos
	Asiento					asientoDoc
	User					usuarioDoc
	User            		usuarioVegetaDoc
	List<Asiento>			asientosDoc
	List<Integer>       	idAsientosDoc = newArrayList	
	Reserva 				reserva
	HibernateUserDAO        userDAO
	HibernateAsientoDAO     asientoDAO
	HibernateReservaDAO     reservaDAO
	HibernateTramoDAO		tramoDAO
	Vuelo          			vuelo
	Aereolinea      		aereolinea
	Asiento 				asientoDoc2
	Asiento					asientoDoc3
	
	@Before
	def void setUp(){
		userDAO						= new HibernateUserDAO
		asientoDAO					= new HibernateAsientoDAO
		reservaDAO					= new HibernateReservaDAO
		tramoDAO				    = new HibernateTramoDAO	
		aereolinea					= new Aereolinea("Aterrizar")
		vuelo          				= new Vuelo(aereolinea)
		aereolinea.vuelosOfertados.add(vuelo)
		testReservaCompraDeAsientos	= new ReservaCompraDeAsientos(userDAO,asientoDAO, reservaDAO, tramoDAO)
		asientoDoc					= new Asiento(new Tramo(200.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista)
		usuarioVegetaDoc            = new User("Vegeta","Saiyan","vegetaUser","vegeta@gmail.com","VegetaPassword",new Date())
		usuarioDoc					= new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date)
		reserva						= new Reserva
		asientoDoc2					= new Asiento(new Tramo(100.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista)
		asientoDoc3					= new Asiento(new Tramo(100.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista)
		asientosDoc					= #[asientoDoc2,asientoDoc3]

		Runner.runInSession[
			userDAO.save(usuarioDoc)
			userDAO.save(usuarioVegetaDoc)
			asientoDAO.save(asientoDoc)
			asientosDoc.forEach[asientoDAO.save(it)]
			null
		]
		asientosDoc.forEach[idAsientosDoc.add(it.id)]
		
	}
	
	@Test
	def void testUnaReservaCompraDeAsientosPuedeReservarUnAsientoParaUnUsuarioExitosamente(){
		val reservaResultado = testReservaCompraDeAsientos.reservar(asientoDoc.id,usuarioDoc.userName)
		Runner.runInSession[
			var usuario = userDAO.loadbyname(usuarioDoc.userName)
			val asiento = asientoDAO.load(asientoDoc.id)
			assertEquals(usuario.reserva.id,reservaResultado.id)
			assertTrue(reservaResultado.asientos.stream.anyMatch[it.id==asiento.id])
			assertEquals(asiento.reserva.id,reservaResultado.id)
			null
		]
		
		
		
	}

	@Test(expected=ExepcionReserva)
	def test001UnatestReservaCompraDeAsientosNoPuedeReservarUnAsientoParaUnUsuarioExitosamentePorqueYaEstabaReservado(){
		
		testReservaCompraDeAsientos.reservar(asientoDoc.id,usuarioDoc.userName)
		
		testReservaCompraDeAsientos.reservar(asientoDoc.id,usuarioDoc.userName)
		
        fail()
	}
	
	@Test
	def test002UnatestReservaCompraDeAsientosPuedeReservarVariosAsientosParaUnUsuarioExitosamente(){
		var reservaResultado = testReservaCompraDeAsientos.reservarAsientos(idAsientosDoc,usuarioDoc.userName)
		assertEquals(reservaResultado.asientos.size,asientosDoc.size)
	}
	
	@Test(expected=ExepcionReserva)
	def test003UnaTestReservaCompraDeAsientosNoPuedeReservarVariosAsientosParaUnUsuarioExitosamentePorqueAlMenosUnoEstabaReservado(){
		
		
		testReservaCompraDeAsientos.reservarAsientos(idAsientosDoc,usuarioDoc.userName)

		testReservaCompraDeAsientos.reservarAsientos(idAsientosDoc,usuarioDoc.userName)
		
		fail()
	}
	
	@Test
	def void test004UnTestReservaCompraDeAsientosPuedeRealizarUnaCompraParaUnUsuarioExitosamente(){
		
		assertTrue(usuarioDoc.compras.isEmpty)
		
		Runner.runInSession[
			usuarioDoc.monedero = 300.00
			userDAO.update(usuarioDoc)

			null
		]
		
		val reservaResultado = testReservaCompraDeAsientos.reservarAsientos(idAsientosDoc, usuarioDoc.userName)
		val compraResultado  = testReservaCompraDeAsientos.comprar(reservaResultado.id, usuarioDoc.userName)
		
		Runner.runInSession[
			val user = userDAO.loadbyname(usuarioDoc.userName)
			val asiento2= asientoDAO.load(asientoDoc2.id)
			val asiento3= asientoDAO.load(asientoDoc3.id)
			val asientos = #[asiento3, asiento2]
			
			assertNull(user.compras.get(0).asientos.get(0).reserva)
			assertNull(user.reserva)
			assertTrue(asientos.stream.allMatch[it.duenio.equals(user)])
			assertTrue(user.compras.stream.anyMatch[it.id == compraResultado.id])
			assertEquals(user.monedero,80, 0.00000000001)

			null
		]
		
		
	}
	
	@Test(expected=ExepcionCompra)
	def void test006UnaTestReservaCompraDeAsientosNoPuedeRealizarUnaCompraParaUnUsuarioExitosamentePorQueNoLeAlcanzaElEfectivo(){
		Runner.runInSession[	
			usuarioDoc.monedero = 2.00
			userDAO.update(usuarioDoc)
			
			null
		]
		
		val reservaResultado = testReservaCompraDeAsientos.reservar(asientoDoc.id,usuarioDoc.userName)
		testReservaCompraDeAsientos.comprar(reservaResultado.id, usuarioDoc.userName)
		fail()

	}
	

	@Test(expected=ExepcionCompra)
	def test007UnaTestReservaCompraDeAsientosNoPuedeRealizarUnaCompraParaUnUsuarioExitosamentePorqueLaReservaEsInvalida(){

		Runner.runInSession[	
			usuarioDoc.monedero = 300.00
			userDAO.update(usuarioDoc)
			
			null
		]
		var reservaResultado = testReservaCompraDeAsientos.reservar(asientoDoc.id,usuarioDoc.userName)

		testReservaCompraDeAsientos.reservarAsientos(idAsientosDoc,usuarioDoc.userName)
		testReservaCompraDeAsientos.comprar(reservaResultado.id, usuarioDoc.userName)
		fail()

	}
	
	@Test
	def test007UnTestReservaDevuelvelLosAsientosDisponiblesDeUnTramo(){
		
		
		val asiento1 = new Asiento(new Tramo(100.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista)
		val asiento2 = new Asiento(new Tramo(200.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Business)
		val asiento3 = new Asiento(new Tramo(300.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Primera)
		
		Runner.runInSession[	
			usuarioVegetaDoc.monedero = 2000.00
			usuarioDoc.monedero = 2000.00
			userDAO.update(usuarioDoc)
			userDAO.update(usuarioVegetaDoc)
			asientoDAO.save(asiento1)
			asientoDAO.save(asiento2)
			asientoDAO.save(asiento3)
			
			null
		]
		
		testReservaCompraDeAsientos.reservar(asiento1.id,usuarioVegetaDoc.userName)
		
		var reservaResultado = testReservaCompraDeAsientos.reservar(asiento2.id,usuarioDoc.userName)
		testReservaCompraDeAsientos.comprar(reservaResultado.id, usuarioDoc.userName)
		
		//Hay que traer los asientos nuevamente, por que se updatean en la base de datos cuando se realiza la operacion del service .comprar
		var unTramoTest = Runner.runInSession[	
			val asientoTest1 = asientoDAO.load(asiento1.id)
			val asientoTest2 = asientoDAO.load(asiento2.id)
			val asientoTest3 = asientoDAO.load(asiento3.id)
			
			var unTramoTest = new Tramo
			unTramoTest.asientos.add(asientoTest1)
			unTramoTest.asientos.add(asientoTest2)
			unTramoTest.asientos.add(asientoTest3)

			
			unTramoTest
		]
		
		assertEquals(unTramoTest.asientosDisponibles.size, 1)


	}
	
	@After
	def void tearDown(){
		userDAO.clearAll
//		Runner.runInSession [
//			
//			val session = Runner.getCurrentSession
//			val nombreDeTablas = session.createNativeQuery("show tables").getResultList
//			session.createNativeQuery("SET FOREIGN_KEY_CHECKS=0;").executeUpdate
//			nombreDeTablas.forEach [
//				session.createNativeQuery("truncate table " + it).executeUpdate
//			]
//			session.createNativeQuery("SET FOREIGN_KEY_CHECKS=1;").executeUpdate
//			null	
//		]
	}
	
	
}


		
		

