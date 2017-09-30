package Busqueda

import org.junit.Test
import static org.junit.Assert.*
import org.junit.Before
import busquedaService.BusquedaService
import busquedaService.BusquedaHibernate
import service.User
import java.util.Date
import runner.Runner

class TestHibernateBusqueda {
		
	BusquedaService busquedaService
	Busqueda		busqueda
	User			usuario
	
	@Before
	def void setUp(){
		
		busquedaService = new BusquedaHibernate
		usuario         = new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date)
	}
	
	@Test
	def void testBusquedaHibernate(){
		
		var filtro     = new FiltroSimple(new CampoAerolinea, "Pepita")
		var costo      = new Costo
		var ascendente = new Ascendente
		
		busqueda = new Busqueda(filtro, costo, ascendente)
		
		Runner.runInSession[ {
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			null
		}]
	}
}