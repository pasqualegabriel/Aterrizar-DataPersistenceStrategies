package Busqueda

import org.junit.Test
import static org.junit.Assert.*
import org.junit.Before

class TestBusqueda {
	
	Filtro   unFiltroSimple
	Filtro   otroFiltroSimple
	
	@Before
	def void setUp(){
		
		unFiltroSimple	 = new FiltroSimple(new CampoAerolinea, "Pepita")
		otroFiltroSimple = new FiltroSimple(new CampoOrigen, "Bs As")
	}
	
	@Test
	def testCampoAerolinea(){
		
		var campoAerolinea = new CampoAerolinea
		
		assertEquals(campoAerolinea.getCampo, "a.tramo.vuelo.aerolinea.nombre")
	}
	
	@Test
	def testCampoCategoria(){
		
		var campoAerolinea = new CampoCategoria
		
		assertEquals(campoAerolinea.getCampo, "a.categoria.nombre")
	}
	
	@Test
	def testCampoFechaDeSalida(){
		
		var campoAerolinea = new FechaDeSalida
		
		assertEquals(campoAerolinea.getCampo, "a.tramo.fechaDeSalida")
	}
	
	@Test
	def testCampoFechaDeEntrada(){
		
		var campoAerolinea = new FechaDeLlegada
		
		assertEquals(campoAerolinea.getCampo, "a.tramo.fechaDeLlegada")
	}
	
	@Test
	def testCampoOrigen(){
		
		var campoAerolinea = new CampoOrigen
		
		assertEquals(campoAerolinea.getCampo, "a.tramo.destinoOrigen.nombre")
	}
	
	@Test
	def testCampoDestino(){
		
		var campoAerolinea = new CampoDestino
		
		assertEquals(campoAerolinea.getCampo, "a.tramo.destinoLlegada.nombre")
	}
	
	@Test
	def testFiltroSimpleConCampoAerolinaYValorPepita(){
		
		var filtroSimple = new FiltroSimple(new CampoAerolinea, "Pepita")

		assertEquals(filtroSimple.getFiltro, "a.tramo.vuelo.aerolinea.nombre = 'Pepita'")
	}
	
	@Test
	def testFiltroCompuestoAndConPrimerFiltroSimpleConCampoAerolinaYValorPepitaYSegundoFiltroSimpleConCampoOrigenYValorBsAs(){
		
		
		var filtroCompuestoAnd = new FiltroCompuesto(unFiltroSimple, otroFiltroSimple, new ComparatorAnd)

		assertEquals(filtroCompuestoAnd.getFiltro, 
		"(a.tramo.vuelo.aerolinea.nombre = 'Pepita') and (a.tramo.destinoOrigen.nombre = 'Bs As')")
	}
	
	@Test
	def testFiltroCompuestoOrConPrimerFiltroSimpleConCampoAerolinaYValorPepitaYSegundoFiltroSimpleConCampoOrigenYValorBsAs(){
		
		
		var filtroCompuestoOr = new FiltroCompuesto(unFiltroSimple, otroFiltroSimple, new ComparatorOr)

		assertEquals(filtroCompuestoOr.getFiltro, 
		"(a.tramo.vuelo.aerolinea.nombre = 'Pepita') or (a.tramo.destinoOrigen.nombre = 'Bs As')")
	}
	
	@Test
	def testCosto(){
		
		var costo = new Costo

		assertEquals(costo.criterio, "a.tramo.precio")
	}
	
	@Test
	def testEscala(){
	
		var costo = new Escala

		assertEquals(costo.criterio, "a.tramo")
	}
	
	@Test
	def testDuracion(){

		var costo = new Duracion

		assertEquals(costo.criterio, "a.tramo.duracion")
	}
	
	@Test
	def testAscendente(){

		var ascendente = new Ascendente

		assertEquals(ascendente.orden, "ASC")
	}
	
	@Test
	def testDescendente(){

		var descendente = new Descendente

		assertEquals(descendente.orden, "DESC")
	}
	
}










