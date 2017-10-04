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
import dao.BusquedaDAO
import daoImplementacion.HibernateBusquedaDAO

class TestHibernateBusqueda {
		
	BusquedaService busquedaService
	Busqueda		busqueda
	BusquedaDAO     busquedaDAO
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
		
		busquedaDAO     = new HibernateBusquedaDAO
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
		
		
		Runner.runInSession[ {
			val sessionAsiento = Runner.currentSession
			sessionAsiento.save(asiento1)
			sessionAsiento.save(asiento2)
			userDAO.save(usuario)
			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroSimpleConCampoCategoriaConCriterioCostoYOrdenAscendenteEncuentraUnaCoincidencia(){
		
		val  campo			  = new CampoCategoria
		val  filtro    		  = new FiltroSimple(campo, "Primera") 
		             
		val  costo      	  = new Costo 
		val  ascendente       = new Ascendente 
		
		busqueda      		  = new Busqueda(filtro, costo, ascendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
			
		Runner.runInSession[ {
			
			var otherUser   = userDAO.load(usuario)
			var otherSearch = busquedaDAO.load(busqueda)
			
			assertEquals(otherUser.userName, otherSearch.user.userName)
			assertEquals(otherSearch.criterio.criterio, costo.criterio)
			assertEquals(otherSearch.filtro.filtro, filtro.filtro)
			assertEquals(otherSearch.orden.orden, ascendente.orden)
			
			assertNotEquals(otherSearch.criterio, costo)
			assertNotEquals(otherSearch.filtro, filtro)
			assertNotEquals(otherSearch.orden, ascendente)
			null
		}]
		

	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoOrConUnFiltroSimpleConCampoCategoriaPrimeraYOtroFiltroSimpleConCampoDestinoConCriterioEscalaYOrdenDescendenteEncuentraDosCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoCategoria,"Primera") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino,   "Bs As") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorOr)
		
		val  escala      	  = new Escala 
		val  descendente      = new Descendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 2)	
		
		Runner.runInSession[ {
			
			
			var otherUser = userDAO.load(usuario)
			var otherSearch = busquedaDAO.load(busqueda)
			assertEquals(otherSearch.criterio.criterio, escala.criterio)
			assertEquals(otherSearch.orden.orden, descendente.orden)
			assertEquals(otherSearch.user.userName, otherUser.userName)

			null
		}]
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoCategoriaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoCategoria,"Primera") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino,  "Rosario") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorAnd)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Descendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	

	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoFechaDeSalidaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new FechaDeSalida,"2017-01-10 15:10:30") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino, "Bs As") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorAnd)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	

	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoFechaDeLlegadaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new FechaDeLlegada,"2017-01-10 15:19:30") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino, "Bs As") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorAnd)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	

	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoOrigenPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoOrigen,"Mar Del Plata") 
		val filtroSimple2     = new FiltroSimple(new CampoDestino, "Bs As") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorAnd)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)

	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoDestinoPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraUnaCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoDestino,"Rosario") 
		val filtroSimple2     = new FiltroSimple(new CampoOrigen, "Mar Del Plata") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorAnd)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 1)	
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoAndConUnFiltroSimpleConCampoAereolineaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraDosCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
		val filtroSimple2     = new FiltroSimple(new CampoOrigen, "Mar Del Plata") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorAnd)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 2)	
	}
	
	@Test
	def void testUnaBusquedaHibernateFiltroCompuestoOrConUnFiltroSimpleConCampoAereolineaPrimeraYOtroFiltroSimpleConCampoDestinoRosarioConCriterioDuracionYOrdenDescendenteEncuentraDosCoincidencia(){
		
		val filtroSimple1     = new FiltroSimple(new CampoAerolinea,"Aterrizar") 
		val filtroSimple2     = new FiltroSimple(new CampoOrigen,   "Mendoza") 
		val filtroCompuesto   = new FiltroCompuesto(filtroSimple1, filtroSimple2, new ComparatorOr)
		
		val  escala      	  = new Duracion 
		val  descendente      = new Ascendente 
		
		busqueda              = new Busqueda(filtroCompuesto, escala, descendente)
		
		assertEquals(busquedaService.buscar(busqueda, usuario).size, 2)	
	}

	@Test
	def void testUnUsurioRealizaDosBusquedas(){
		
			initializeSearchs
			val ultima10Busquedas = busquedaService.list(usuario)
			assertEquals(10,ultima10Busquedas.size)
			assertTrue(ultima10Busquedas.get(0).orden.orden.equals("DESC"))
			assertTrue(ultima10Busquedas.stream.allMatch[it.user.userName.equals(usuario.userName)])
			assertTrue(ultima10Busquedas.stream.allMatch[it.criterio.criterio.equals("a.tramo.duracion")])
			assertFalse(ultima10Busquedas.stream.anyMatch[it.criterio.criterio.equals("a.tramo")])
			assertFalse(ultima10Busquedas.stream.anyMatch[it.criterio.criterio.equals("a.tramo.precio")])
			assertEquals(9,ultima10Busquedas.filter[it.orden.orden.equals("ASC")].size)
			assertEquals(1,ultima10Busquedas.filter[it.orden.orden.equals("DESC")].size)
			assertTrue(ultima10Busquedas.stream.allMatch[it.filtro.filtro.equals("a.tramo.vuelo.aerolinea.nombre = 'Aterrizar'" )])
			assertFalse(ultima10Busquedas.stream.anyMatch[it.filtro.filtro.equals("a.tramo.vuelo.aerolinea.nombre = 'Despegar'" )])
					
	}
	
	/** Proposito: busquedaService realiza  13 busquedas y las Persiste, 9 con orden Ascendente, 4 con orden desendente, 
	 * 	10 conUnCriterio Duracion, 2 con criterio escala y 1 con criterio costo, todos tiene filtro
	 *  simple con el campo aerolinia, pero 10 con el valor aterrizar y 3 c valor despegar
	 */
	def void initializeSearchs(){
		val escala      	  = new Costo 
		val ascendente        = new Descendente		
		val filtroSimple      = new FiltroSimple(new CampoAerolinea,"Despegar") 
		val busqueda0         = new Busqueda(filtroSimple, escala, ascendente)
		
		val escala1           = new Escala 
		val ascendente1       = new Descendente
		val  filtroSimple1    = new FiltroSimple(new CampoAerolinea,"Despegar") 
		val	busqueda1		  = new Busqueda(filtroSimple1, escala1, ascendente1)

		val criterio2         = new Escala 
		val ascendente2       = new Descendente
		val filtroSimple2     = new FiltroSimple(new CampoAerolinea,"Despegar") 
		val	busqueda2		  = new Busqueda(filtroSimple2, criterio2, ascendente2)
		
		val criterio3         = new Duracion 
		val ascendente3       = new Ascendente
		val filtroSimple3     = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda3		  = new Busqueda(filtroSimple3, criterio3, ascendente3)
		
		val criterio4         = new Duracion 
		val ascendente4       = new Ascendente
		val filtroSimple4     = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda4		  = new Busqueda(filtroSimple4, criterio4, ascendente4)
		
		val criterio5         = new Duracion 
		val ascendente5       = new Ascendente
		val filtroSimple5     = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda5		  = new Busqueda(filtroSimple5, criterio5, ascendente5)
		
		val criterio6         = new Duracion 
		val ascendente6       = new Ascendente
		val filtroSimple6     = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda6		  = new Busqueda(filtroSimple6, criterio6, ascendente6)
		
		val criterio7         = new Duracion 
		val ascendente7       = new Ascendente
		val filtroSimple7     = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda7		  = new Busqueda(filtroSimple7, criterio7, ascendente7)
		
		val criterio8         = new Duracion 
		val ascendente8       = new Ascendente
		val filtroSimple8     = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda8		  = new Busqueda(filtroSimple8, criterio8, ascendente8)
		
		val criterio9         = new Duracion 
		val ascendente9       = new Ascendente
		val filtroSimple9     = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda9		  = new Busqueda(filtroSimple9, criterio9, ascendente9)
		
		val criterio10        = new Duracion 
		val ascendente10      = new Ascendente
		val filtroSimple10    = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda10		  = new Busqueda(filtroSimple10, criterio10, ascendente10)
		
		val criterio11        = new Duracion 
		val ascendente11      = new Ascendente
		val filtroSimple11    = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda11		  = new Busqueda(filtroSimple11, criterio11, ascendente11)
		
		val criterio12        = new Duracion 
		val ascendente12      = new Descendente
		val filtroSimple12_1  = new FiltroSimple(new CampoAerolinea,"Aterrizar")
		val	busqueda12		  = new Busqueda(filtroSimple12_1, criterio12, ascendente12)
		

		busquedaService.buscar(busqueda0 , usuario)
		busquedaService.buscar(busqueda1 , usuario)
		busquedaService.buscar(busqueda2 , usuario)
		busquedaService.buscar(busqueda3 , usuario)
		busquedaService.buscar(busqueda4 , usuario)
		busquedaService.buscar(busqueda5 , usuario)
		busquedaService.buscar(busqueda6 , usuario)
		busquedaService.buscar(busqueda7 , usuario)
		busquedaService.buscar(busqueda8 , usuario)
		busquedaService.buscar(busqueda9 , usuario)
		busquedaService.buscar(busqueda10, usuario)
		busquedaService.buscar(busqueda11, usuario)
		busquedaService.buscar(busqueda12, usuario)
	
	}
	
	@After
	def void tearDown(){
		userDAO.clearAll
	}

	
}






