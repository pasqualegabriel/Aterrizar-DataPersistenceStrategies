package Busqueda

import org.junit.Test
import static org.junit.Assert.*
import org.junit.Before

class BusquedaTest {
	
	Filtro unFiltroSimple
	Filtro otroFiltroSimple
	
	@Before
	def void setUp(){
		
		unFiltroSimple	 = new FiltroSimple(new CampoAerolinea, "Pepita")
		otroFiltroSimple = new FiltroSimple(new CampoOrigen, "Bs As")
	}
	
	@Test
	def testElCampoAerolineaDevuelve     (){
		
		var campoAerolinea = new CampoAerolinea
		
		assertEquals(campoAerolinea.getCampo, "asiento.nombreAerolinea")
	}
	
	@Test
	def testElCampoCategoriaDevuelve     (){
		
		var campoAerolinea = new CampoCategoria
		
		assertEquals(campoAerolinea.getCampo, "asiento.nombreCategoria")
	}
	
	@Test
	def testElCampoFechaDeSalidaDevuelve     (){
		
		var campoAerolinea = new FechaDeSalida
		
		assertEquals(campoAerolinea.getCampo, "asiento.fechaDeSalida")
	}
	
	@Test
	def testElCampoFechaDeEntradaDevuelve     (){
		
		var campoAerolinea = new FechaDeEntrada
		
		assertEquals(campoAerolinea.getCampo, "asiento.fechaDeEntrada")
	}
	
	@Test
	def testElCampoOrigenDevuelve     (){
		
		var campoAerolinea = new CampoOrigen
		
		assertEquals(campoAerolinea.getCampo, "asiento.origen")
	}
	
	@Test
	def testElCampoDestinoDevuelve     (){
		
		var campoAerolinea = new CampoDestino
		
		assertEquals(campoAerolinea.getCampo, "asiento.destino")
	}
	
	@Test
	def testFiltroSimpleConCampoAerolinaYValorPepita(){
		
		var filtroSimple = new FiltroSimple(new CampoAerolinea, "Pepita")

		assertEquals(filtroSimple.getFiltro, "asiento.nombreAerolinea == Pepita")
	}
	
	@Test
	def testFiltroCompuestoConCampoAerolinaYValorPepita(){
		
		
		var filtroSimple = new FiltroAnd(unFiltroSimple, otroFiltroSimple)

		assertEquals(filtroSimple.getFiltro, "(asiento.nombreAerolinea == Pepita) and (asiento.destino == Bs As)")
	}
}










