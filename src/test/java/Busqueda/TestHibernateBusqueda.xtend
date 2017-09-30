package Busqueda

import org.junit.Test
import static org.junit.Assert.*
import org.junit.Before
import busquedaService.BusquedaService
import busquedaService.BusquedaHibernate
import service.User
import java.util.Date
import runner.Runner
import dao.UserDAO
import daoImplementacion.HibernateUserDAO
import aereolinea.Asiento
import aereolinea.Tramo
import categorias.Categoria
import aereolinea.Vuelo
import aereolinea.Aereolinea
import categorias.Primera
import asientoServicio.Reserva

class TestHibernateBusqueda {
		
	BusquedaService busquedaService
	Busqueda		busqueda
	User			usuario
	UserDAO         userDAO
	Asiento 	    asiento
	Tramo		    tramo
	Categoria 	    categoria
	Reserva			reserva
	Vuelo           vuelo
		
	@Before
	def void setUp(){
		
		userDAO         = new HibernateUserDAO
		busquedaService = new BusquedaHibernate
		usuario         = new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date)
		vuelo           = new Vuelo(new Aereolinea)
		tramo      		= new Tramo(10.00, vuelo)
		reserva 		= new Reserva
		categoria    	= new Primera
		asiento			= new Asiento(tramo, categoria)
		asiento.reserva = reserva
	}
	
	@Test
	def void testBusquedaHibernate(){
		
		var filtro     = new FiltroSimple(new CampoCategoria, "Primera") 
		                 // CampoCategoria ya funcionan
		var costo      = new Costo //Costo y Escala funcionan, falta Duracion
		var ascendente = new Ascendente //Descendente y Ascendente funcionan
		
		busqueda       = new Busqueda(filtro, costo, ascendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento)
						
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			

			null
		}]
	}
	


	
}








