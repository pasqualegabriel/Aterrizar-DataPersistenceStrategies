package daoImplementacion

import Busqueda.Busqueda
import dao.BusquedaDAO
import org.junit.Before
import org.junit.Test
import Busqueda.FiltroSimple
import Busqueda.CampoAerolinea
import Busqueda.CampoOrigen
import Busqueda.Duracion
import Busqueda.Ascendente
import Busqueda.Filtro
import Busqueda.Criterio
import Busqueda.Orden
import runner.Runner
import static org.junit.Assert.*
import Busqueda.FiltroCompuesto
import org.junit.After
import service.TruncateTables
import Busqueda.Comparator

class TesBusquedaDAO {
	BusquedaDAO busquedaDAOSuj
	Busqueda 	busquedaDoc
	Filtro		filtroDoc
	Criterio	criterioDoc
	Orden		ordenDoc
	Filtro 		filtroSimple1
	
	@Before
	def void setUp(){
		
		filtroSimple1     		    = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
		var filtroSimple2    		= new FiltroSimple(new CampoOrigen,   "Mendoza") 
		
		filtroDoc   				= new FiltroCompuesto(filtroSimple1, filtroSimple2, Comparator.Or)
		criterioDoc      	 		= new Duracion 
		ordenDoc      				= new Ascendente 
		
		busquedaDoc 				= new Busqueda(filtroDoc, criterioDoc, ordenDoc)
		busquedaDAOSuj				= new HibernateBusquedaDAO

	}
	
	@Test
	def void testLaBusquedaDAoSujSabeHacerUnSaveYRecuperarseObtieneObjetosSimilares(){
		
		Runner.runInSession[
	
			busquedaDAOSuj.save(busquedaDoc)
			
			var otherSearch = busquedaDAOSuj.load(busquedaDoc)

			assertEquals(busquedaDoc.filtro,otherSearch.filtro)
			assertEquals(busquedaDoc.criterio,otherSearch.criterio)
			assertEquals(busquedaDoc.orden,otherSearch.orden)
			assertEquals(busquedaDoc,otherSearch)
			
			null
		]
	}
	
	@Test
	def void testAlHacerUnSaveYCerrarLaSeccionCuandoAbrimosUnaNuevaYHacemosLoadLasIntanciasDelObjetoSonDiferentes(){
			
		Runner.runInSession[
			busquedaDAOSuj.save(busquedaDoc)
			null
		]
	
	
		Runner.runInSession[
			var otherSearch = busquedaDAOSuj.load(busquedaDoc)
			
			assertEquals(busquedaDoc.filtro.getFiltro,otherSearch.filtro.getFiltro)
			assertEquals(busquedaDoc.criterio.criterio,otherSearch.criterio.criterio)
			assertEquals(busquedaDoc.orden.orden,otherSearch.orden.orden)
			
			assertNotEquals(busquedaDoc.filtro,otherSearch.filtro)
			assertNotEquals(busquedaDoc.criterio,otherSearch.criterio)
			assertNotEquals(busquedaDoc.orden,otherSearch.orden)
			assertNotEquals(busquedaDoc,otherSearch)
			
			null
		]
	}
	
	@After
	def void tearDown(){

		new TruncateTables => [ vaciarTablas ]

	}
	
}