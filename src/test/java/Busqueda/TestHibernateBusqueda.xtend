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
import org.junit.After
import categorias.Business
import aereolinea.Destino
import java.time.LocalDateTime

class TestHibernateBusqueda {
		
	BusquedaService busquedaService
	Busqueda		busqueda
	User			usuario
	UserDAO         userDAO
	Asiento 	    asiento1
	Asiento 	    asiento2
	Tramo		    tramo1
	Tramo		    tramo2
	Categoria 	    categoria1
	Categoria 	    categoria2
	Reserva			reserva1
	Reserva			reserva2
	Vuelo           vuelo
		
	@Before
	def void setUp(){

		userDAO         = new HibernateUserDAO
		busquedaService = new BusquedaHibernate
		usuario         = new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date)
		vuelo           = new Vuelo(new Aereolinea("Aterrizar"))
		
		tramo1     		= new Tramo(10.00, vuelo, new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00))
		reserva1 		= new Reserva
		categoria1    	= new Primera
		asiento1		= new Asiento(tramo1, categoria1)
		asiento1.reserva = reserva1
		
		tramo2     		= new Tramo(20.00, vuelo, new Destino("Mar Del Plata"), new Destino("Bs As"), LocalDateTime.of(2017, 1, 10, 10 ,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00))
		reserva2 		= new Reserva
		categoria2    	= new Business
		asiento2		= new Asiento(tramo2, categoria2)
		asiento2.reserva = reserva2
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroSimpleConCampoCategoriaConCriterioCostoYOrdenAscendenteEncuentraUnaCoincidencia(){
		
		val  campo			  = new CampoCategoria
		val  filtro    		  = new FiltroSimple(campo, "Primera") 
		             
		val  costo      	  = new Costo 
		val  ascendente       = new Ascendente 
		
		busqueda       = new Busqueda(filtro, costo, ascendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
			
			assertEquals(0,usuario.busquedas.size)		
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			var otherUser = userDAO.load(usuario)
			assertTrue(otherUser.busquedas.stream.anyMatch[it.criterio.equals(costo)])
			assertTrue(otherUser.busquedas.stream.anyMatch[it.filtro.equals(filtro)])
			assertTrue(otherUser.busquedas.stream.anyMatch[it.orden.equals(ascendente)])
			assertEquals(1,otherUser.busquedas.size)

			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoOrConUnFiltroSimpleConCampoCategoriaPrimeraYOtroFiltroSimpleConCampoDestinoConCriterioEscalaYOrdenDescendenteEncuentraDosCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoCategoria,"Primera") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino,   "Bs As") 
		val filtroCompuesto   = new FiltroOr(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Escala 
		val  descendente      = new Descendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 2)	
			var otherUser = userDAO.load(usuario)
			assertTrue(otherUser.busquedas.stream.anyMatch[it.criterio.equals(escala)])
			assertTrue(otherUser.busquedas.stream.anyMatch[it.filtro.equals(filtroCompuesto)])
			assertTrue(otherUser.busquedas.stream.anyMatch[it.orden.equals(descendente)])

			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoCategoriaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoCategoria,"Primera") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino,  "Rosario") 
		val filtroCompuesto   = new FiltroAnd(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Descendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoFechaDeSalidaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new FechaDeSalida,"2017-01-10 15:10:30") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino, "Bs As") 
		val filtroCompuesto   = new FiltroAnd(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoFechaDeLlegadaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new FechaDeLlegada,"2017-01-10 15:19:30") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino, "Bs As") 
		val filtroCompuesto   = new FiltroAnd(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoOrigenPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoOrigen,"Mar Del Plata") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino, "Bs As") 
		val filtroCompuesto   = new FiltroAnd(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	

			
			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoDestinoPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoDestino,"Rosario") 
		val filtroSimple2     = new FiltroSimple(new CampoOrigen, "Mar Del Plata") 
		val filtroCompuesto   = new FiltroAnd(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoAereolineaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraDosCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
		val filtroSimple2     = new FiltroSimple(new CampoOrigen, "Mar Del Plata") 
		val filtroCompuesto   = new FiltroAnd(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 2)	
			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoOrConUnFiltroSimpleConCampoAereolineaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraDosCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
		val filtroSimple2     = new FiltroSimple(new CampoOrigen,   "Mendoza") 
		val filtroCompuesto   = new FiltroOr(filtroSimple1, filtroSimple2)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		Runner.runInSession[ {
			
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
			assertEquals(busquedaService.buscar(busqueda, usuario).size, 2)
			null
		}]
		
	}
	
//	@Test(expected=IllegalArgumentException)
//	def void testUnaBusquedaHibernateFiltroCompuestoOrConUnFiltroSimpleConCampoAereolineaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraDosCoincidencia(){
//		
//		val filtroSimple1     = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
//		val filtroSimple2     = new FiltroSimple(new CampoOrigen, "Mendoza") 
//		val filtroCompuesto   = new FiltroOr(filtroSimple1, filtroSimple2)
//		
//		val  escala      	  = new Duracion 
//		val  descendente      = new Ascendente 
//		
//		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
//		
//		Runner.runInSession[ {
//			
//			val sessionAsiento = Runner.currentSession
//			sessionAsiento.save(asiento1)
//			sessionAsiento.save(asiento2)
//						
//			userDAO.save(usuario)
//			busquedaService.buscar(busqueda, usuario)
//			fail()
//			null
//		}]
//		
//	}
//
	@Test
	def void testUnUsurioRealizaDosBusquedas(){
		
		val filtroSimple1     = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
		val filtroSimple2     = new FiltroSimple(new CampoOrigen,   "Mendoza")
		val filtroSimple3     = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
		val filtroSimple4     = new FiltroSimple(new CampoOrigen,   "Mendoza")  
		
		val filtroCompuesto   = new FiltroOr(filtroSimple1, filtroSimple2)
		val filtroCompuesto2  = new FiltroAnd(filtroSimple3,filtroSimple4)
		
		val  escala      	  = new Duracion 
		val  ascendente       = new Ascendente
		val  escala2      	  = new Duracion 
		val  ascendente2       = new Ascendente  
		
		busqueda              = new Busqueda(filtroCompuesto, escala, ascendente)
		val	busqueda2		  = new Busqueda(filtroCompuesto2, escala2, ascendente2)
		Runner.runInSession[ {

			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
						
			userDAO.save(usuario)
	
			busquedaService.buscar(busqueda, usuario)
			//busquedaService.buscar(busqueda, usuario)
			busquedaService.buscar(busqueda2, usuario)
			//for(var i=0;i<10;i++){busquedaService.buscar(busqueda, usuario)}
			assertEquals(busquedaService.list(usuario).size, 2)
//			assertTrue(busquedaService.list(usuario).stream.anyMatch[it.filtro.equals(filtroCompuesto)])
//			assertTrue(busquedaService.list(usuario).stream.anyMatch[it.criterio.equals(escala)])
//			assertTrue(busquedaService.list(usuario).stream.anyMatch[it.orden.equals(ascendente)])
			null
		}]
		
	}
	
	@After
	def void tearDown(){
		userDAO.clearAll
	}

	
}






