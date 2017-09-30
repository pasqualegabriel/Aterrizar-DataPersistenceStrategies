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
import userDAO.UserDAO
import org.mockito.Mock
import org.mockito.MockitoAnnotations

class TestReservaCompraDeAsientos {
	
	AsientoService 	testReservaCompraDeAsientos
	Asiento			asientoDoc
	User			usuarioDoc
	List<Asiento>	asientosDoc=newArrayList
	Reserva 		reserva
	@Mock UserDAO   userDAO
	
	@Before
	def void setUp(){
		MockitoAnnotations.initMocks(this)
		testReservaCompraDeAsientos	= new ReservaCompraDeAsientos(userDAO)
		asientoDoc					= new Asiento(new Tramo(200.00),new Turista)
		usuarioDoc					= new User
		reserva						= new Reserva
		asientosDoc.add(new Asiento(new Tramo(100.00),new Turista))
		asientosDoc.add(new Asiento(new Tramo(100.00),new Turista))
		
	}
	
	@Test
	def test000UnatestReservaCompraDeAsientosPuedeReservarUnAsientoParaUnUsuarioExitosamente(){
		
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
	def test004UnTestReservaCompraDeAsientosPuedeRealizarUnaCompraParaUnUsuarioExitosamente(){
		
		assertTrue(usuarioDoc.compras.isEmpty)
		var reservaResultado = testReservaCompraDeAsientos.reservarAsientos(asientosDoc, usuarioDoc)
		
		usuarioDoc.monedero = 300.00
		
		var compraResultado  = testReservaCompraDeAsientos.comprar(reservaResultado, usuarioDoc)
		assertNull(usuarioDoc.reserva)
		assertTrue(asientosDoc.stream.allMatch[it.duenio.equals(usuarioDoc)])
		assertTrue(usuarioDoc.compras.contains(compraResultado))
		assertEquals(usuarioDoc.monedero,80, 0.00000000001)
		
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
		var unUsuario = new User
		var asiento1 = new Asiento(new Tramo(100.00),new Turista)
		var asiento2 = new Asiento(new Tramo(200.00),new Business)
		var asiento3 = new Asiento(new Tramo(300.00),new Primera)
		
		unUsuario.monedero = 2000.00
		usuarioDoc.monedero = 2000.00
		testReservaCompraDeAsientos.reservar(asiento1,unUsuario)
		
		var reservaResultado = testReservaCompraDeAsientos.reservar(asiento2,usuarioDoc)
		testReservaCompraDeAsientos.comprar(reservaResultado, usuarioDoc)
		
		var unTramoTest = new Tramo
		unTramoTest.asientos.add(asiento1)
		unTramoTest.asientos.add(asiento2)
		unTramoTest.asientos.add(asiento3)

		assertEquals(unTramoTest.asientosDisponibles.size, 1)


	}

	
}


		
		

