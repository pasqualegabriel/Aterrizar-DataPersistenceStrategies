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
import dao.UserDAO
import aereolinea.Vuelo
import aereolinea.Aereolinea
import aereolinea.Destino
import java.time.LocalDateTime
import daoImplementacion.HibernateUserDAO
import org.junit.After
import java.util.Date
import runner.Runner

class TestReservaCompraDeAsientos {
	
	AsientoService 	testReservaCompraDeAsientos
	Asiento			asientoDoc
	User			usuarioDoc
	User            usuarioVegetaDoc
	List<Asiento>	asientosDoc
	Reserva 		reserva
	UserDAO         userDAO
	Vuelo           vuelo
	Aereolinea      aereolinea
	
	@Before
	def void setUp(){
		userDAO						= new HibernateUserDAO
		asientosDoc					= newArrayList
		aereolinea					= new Aereolinea("Aterrizar")
		vuelo          				= new Vuelo(aereolinea)
		aereolinea.vuelosOfertados.add(vuelo)
		testReservaCompraDeAsientos	= new ReservaCompraDeAsientos(userDAO)
		asientoDoc					= new Asiento(new Tramo(200.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista)
		usuarioVegetaDoc            = new User("Vegeta","Saiyan","vegetaUser","vegeta@gmail.com","VegetaPassword",new Date())
		usuarioDoc					= new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date)
		reserva						= new Reserva
		asientosDoc.add(new Asiento(new Tramo(100.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista))
		asientosDoc.add(new Asiento(new Tramo(100.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista))
		
		Runner.runInSession[{
			userDAO.save(usuarioDoc)
			userDAO.save(usuarioVegetaDoc)
			null
		}]
	}
	
	@Test
	def void testUnaReservaCompraDeAsientosPuedeReservarUnAsientoParaUnUsuarioExitosamente(){
		
		var reservaResultado = testReservaCompraDeAsientos.reservar(asientoDoc,usuarioDoc)
			
		assertTrue(usuarioDoc.reserva.equals(reservaResultado))
		assertTrue(reservaResultado.asientos.contains(asientoDoc))
		assertEquals(asientoDoc.reserva,reservaResultado)
	}

	@Test(expected=ExepcionReserva)
	def test001UnatestReservaCompraDeAsientosNoPuedeReservarUnAsientoParaUnUsuarioExitosamentePorqueYaEstabaReservado(){
		
		testReservaCompraDeAsientos.reservar(asientoDoc,usuarioDoc)
		
		testReservaCompraDeAsientos.reservar(asientoDoc,usuarioDoc)
		
        fail()
	}
	
	@Test
	def test002UnatestReservaCompraDeAsientosPuedeReservarVariosAsientosParaUnUsuarioExitosamente(){
		var reservaResultado = testReservaCompraDeAsientos.reservarAsientos(asientosDoc,usuarioDoc)
		assertEquals(reservaResultado.asientos.size,asientosDoc.size)
	}
	
	@Test(expected=ExepcionReserva)
	def test003UnaTestReservaCompraDeAsientosNoPuedeReservarVariosAsientosParaUnUsuarioExitosamentePorqueAlMenosUnoEstabaReservado(){

		testReservaCompraDeAsientos.reservarAsientos(asientosDoc,usuarioDoc)

		testReservaCompraDeAsientos.reservarAsientos(asientosDoc,usuarioDoc)
		
		fail()
	}
	
	@Test
	def void test004UnTestReservaCompraDeAsientosPuedeRealizarUnaCompraParaUnUsuarioExitosamente(){
		
		assertTrue(usuarioDoc.compras.isEmpty)
		var reservaResultado = testReservaCompraDeAsientos.reservarAsientos(asientosDoc, usuarioDoc)
		
		usuarioDoc.monedero = 300.00
		
		var compraResultado  = testReservaCompraDeAsientos.comprar(reservaResultado, usuarioDoc)
		assertNull(usuarioDoc.reserva)
		assertTrue(asientosDoc.stream.allMatch[it.duenio.equals(usuarioDoc)])
		assertTrue(usuarioDoc.compras.contains(compraResultado))
		assertEquals(usuarioDoc.monedero,80, 0.00000000001)
		
		Runner.runInSession[{
			assertNull(userDAO.load(usuarioDoc).compras.get(0).asientos.get(0).reserva)
			
			null
		}]
		
		
	}
	
	@Test(expected=ExepcionCompra)
	def test006UnaTestReservaCompraDeAsientosNoPuedeRealizarUnaCompraParaUnUsuarioExitosamentePorQueNoLeAlcanzaElEfectivo(){
			
			usuarioDoc.monedero = 30.00
		
			var reservaResultado = testReservaCompraDeAsientos.reservar(asientoDoc,usuarioDoc)
			testReservaCompraDeAsientos.comprar(reservaResultado, usuarioDoc)
			fail()

	}
	

	@Test(expected=ExepcionCompra)
	def test007UnaTestReservaCompraDeAsientosNoPuedeRealizarUnaCompraParaUnUsuarioExitosamentePorqueLaReservaEsInvalida(){

		usuarioDoc.monedero = 300.00
		var reservaResultado = testReservaCompraDeAsientos.reservar(asientoDoc,usuarioDoc)

		testReservaCompraDeAsientos.reservarAsientos(asientosDoc,usuarioDoc)
		testReservaCompraDeAsientos.comprar(reservaResultado, usuarioDoc)
		fail()

	}
	
	@Test
	def test007UnTestReservaDevuelvelLosAsientosDisponiblesDeUnTramo(){
		
		
		var asiento1 = new Asiento(new Tramo(100.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Turista)
		var asiento2 = new Asiento(new Tramo(200.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Business)
		var asiento3 = new Asiento(new Tramo(300.00, vuelo,new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)),new Primera)
		
		usuarioVegetaDoc.monedero = 2000.00
		usuarioDoc.monedero = 2000.00
		testReservaCompraDeAsientos.reservar(asiento1,usuarioVegetaDoc)
		
		var reservaResultado = testReservaCompraDeAsientos.reservar(asiento2,usuarioDoc)
		testReservaCompraDeAsientos.comprar(reservaResultado, usuarioDoc)
		
		var unTramoTest = new Tramo
		unTramoTest.asientos.add(asiento1)
		unTramoTest.asientos.add(asiento2)
		unTramoTest.asientos.add(asiento3)

		assertEquals(unTramoTest.asientosDisponibles.size, 1)


	}
	
	@After
	def void tearDown(){
		userDAO.clearAll
	}
	
}


		
		

