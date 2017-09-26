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

class TestReservaCompraDeAsientos {
	
	AsientoService 	testReservaCompraDeAsientos
	Asiento			asientoDoc
	User			usuarioDoc
	List<Asiento>	asientosDoc=newArrayList
	Reserva 		reserva
		
	@Before
	def void setUp(){

		testReservaCompraDeAsientos	= new ReservaCompraDeAsientos
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
	def test004UnaTestReservaCompraDeAsientosPuedeRealizarUnaCompraParaUnUsuarioExitosamente(){
		
		assertTrue(usuarioDoc.compras.isEmpty)
		var reservaResultado = testReservaCompraDeAsientos.reservarAsientos(asientosDoc,usuarioDoc)
		
		usuarioDoc.monedero = 300.00
		
		var compraResultado  = testReservaCompraDeAsientos.comprar(reservaResultado, usuarioDoc)
		assertNull(usuarioDoc.reserva)
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
	
}


		
		

