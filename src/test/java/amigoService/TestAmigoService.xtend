package amigoService

import org.junit.Test
import org.junit.Before
import static org.junit.Assert.*
import org.junit.After
import unq.amistad.RelacionesDeAmistades
import org.mockito.MockitoAnnotations
import service.User

import daoImplementacion.Neo4jDAO
import unq.amistad.EstadoDeSolicitud
import java.util.List
import unq.amistad.Solicitud
import java.util.ArrayList
import runner.Runner
import java.util.Date
import daoImplementacion.HibernateUserDAO
import service.TruncateTables
import java.time.format.DateTimeFormatter
import java.time.LocalDateTime
import java.time.LocalDate
import java.time.ZoneId
import unq.amistad.Mensaje

class TestAmigoService {
	

	RelacionesDeAmistades 	amigoService
	User 				  	pepita
	User 				  	dionisia
	User				  	loqui
	Neo4jDAO				neo4jDao
	
	@Before
	def void setUp(){
		
		MockitoAnnotations.initMocks(this)
		amigoService = new RelacionesDeAmistades
		neo4jDao     = new Neo4jDAO
		pepita		 = new User("PepitaUser")
		dionisia	 = new User("DionisiaUser")
		loqui		 = new User("Loqui")
		neo4jDao.save(pepita)
		neo4jDao.save(dionisia)
		neo4jDao.save(loqui)
		

	
	}

	
	@Test
	def tirarBase(){
		assertTrue(true)
	}
	
	@Test
	def elUsuarioPepitaLeEnviaUnaSolicitudDeAmistadAlUsuarioDionisia(){
		amigoService.mandarSolicitud("PepitaUser","DionisiaUser")
		var solicitudes = amigoService.verSolicitudes("DionisiaUser")
		var users			   = #["PepitaUser"]
		validarIntegridadesSolicitudes(users,solicitudes,1)
	}
	@Test
	def elUsuarioDionisiaUserLeLlegaDosSolicitudes(){
		this.enviarSolicitudes
		var solicitudes = amigoService.verSolicitudes("DionisiaUser")
		var users			   = #["Loqui", "PepitaUser"]
		
		validarIntegridadesSolicitudes(users,solicitudes,2)
		
	}
	
	@Test
	def elUsuarioDionisiaAceptaLaSolicitudDeLoquiLaSolicitudPasaAEstarAceptadaSeIntanciaUnaRelacionDeAmistadYAhoraTieneUnAmigoDionisia(){
		val userDAO = new HibernateUserDAO
		pepita = new User("Pepita", "LaGolondrina", "PepitaUser", "pepitagolondrina@gmail.com", "password", new Date())
		dionisia = new User("Dionisia", "LaGolondrinaVieja", "DionisiaUser", "dionisiagolondrina@gmail.com", "password", new Date())	
		loqui = new User("Loqui", "ElPerro", "Loqui", "perroPerrucho@gmail.com", "password", new Date())	
		val usuarios = #[pepita, dionisia, loqui]
		
		Runner.runInSession[
			usuarios.forEach[userDAO.save(it)]
			null
		]
		
		/**Antes de aceptar  una Solicitud */
		this.enviarSolicitudes
		var solicitudPendiente = amigoService.verSolicitudes("DionisiaUser")
		var users			   = #["Loqui", "PepitaUser"]
		assertEquals(0, amigoService.amigos("DionisiaUser").size)
		validarIntegridadesSolicitudes(users,solicitudPendiente,2)
		
		/**Despues de aceptar  una Solicitud */
		amigoService.aceptarSolicitud("DionisiaUser","Loqui");
		
		var amigosDeDionisia= amigoService.amigos("DionisiaUser");
		
		assertEquals(1, amigosDeDionisia.size)	
		assertEquals(amigosDeDionisia.get(0).userName,"Loqui");
		var solicitudPendienteDespuesDeAceptarUnaSolicitud = amigoService.verSolicitudes("DionisiaUser")
		var users2		   = #["PepitaUser"]
		validarIntegridadesSolicitudes(users2,solicitudPendienteDespuesDeAceptarUnaSolicitud,1)
		
	}


	@Test
	def ElUsuarioDionisiaAceptaLaSolicitudDePepitaEnEl2000LaSolicitudDeLoquiEnLaActualidadYLuegoPideLosAmigosDespuesDel2001DevolviendoALoqui(){
		val userDAO = new HibernateUserDAO
		pepita = new User("Pepita", "LaGolondrina", "PepitaUser", "pepitagolondrina@gmail.com", "password", new Date())
		dionisia = new User("Dionisia", "LaGolondrinaVieja", "DionisiaUser", "dionisiagolondrina@gmail.com", "password", new Date())	
		loqui = new User("Loqui", "ElPerro", "Loqui", "perroPerrucho@gmail.com", "password", new Date())	
		val usuarios = #[pepita, dionisia, loqui]
		
		Runner.runInSession[
			usuarios.forEach[userDAO.save(it)]
			null
		]
		
		/**Antes de aceptar  una Solicitud */
		this.enviarSolicitudes
		var solicitudPendiente = amigoService.verSolicitudes("DionisiaUser")
		var users			   = #["Loqui", "PepitaUser"]
		assertEquals(0, amigoService.amigos("DionisiaUser").size)
		validarIntegridadesSolicitudes(users,solicitudPendiente,2)
		
		/**Despues de aceptar  una Solicitud */
		amigoService.aceptarSolicitud("DionisiaUser","Loqui");
		
		var fecha = "09/10/2000"
		var formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
		var zoneId = ZoneId.systemDefault();
		var fechaformated = LocalDateTime.from(LocalDate.parse(fecha, formatter).atStartOfDay()).atZone(zoneId).toEpochSecond();
		
		neo4jDao.aceptarSolicitudDeAmistad("DionisiaUser","PepitaUser",fechaformated)
		
		var amigosDeDionisia= amigoService.amigos("DionisiaUser")
		
		assertEquals(2, amigosDeDionisia.size)	
		
		/**Finalmente Se Piden Los Amigos Despues Del 2001 */
		var fecha2 = "01/01/2001"
		var fechaformat = LocalDateTime.from(LocalDate.parse(fecha2, formatter).atStartOfDay())
	
		
		var amigosDeDionisiaDespuesDel2001= amigoService.amigosDespuesDe("DionisiaUser",fechaformat)
		
		assertEquals(1, amigosDeDionisiaDespuesDel2001.size)	
		assertEquals(amigosDeDionisiaDespuesDel2001.get(0).userName,"Loqui");
		
	}
	
	@Test
	def elUsuarioDionisiaLeMandaUnMensajeASuAmigoLoqui(){
		val userDAO = new HibernateUserDAO
		dionisia = new User("Dionisia", "LaGolondrinaVieja", "DionisiaUser", "dionisiagolondrina@gmail.com", "password", new Date())	
		loqui = new User("Loqui", "ElPerro", "Loqui", "perroPerrucho@gmail.com", "password", new Date())	
		val usuarios = #[dionisia, loqui]
		
		Runner.runInSession[
			usuarios.forEach[userDAO.save(it)]
			null
		]
		amigoService.mandarSolicitud("Loqui","DionisiaUser")
		amigoService.aceptarSolicitud("DionisiaUser","Loqui");
		
		var mensajesDeLoquiConDionisiaAntes= amigoService.mensajes("Loqui","DionisiaUser")
		
		assertTrue (mensajesDeLoquiConDionisiaAntes.isEmpty)
		
		
		val mensaje = new Mensaje("Hola!",LocalDateTime.now)
		
		amigoService.enviar("DionisiaUser",mensaje,"Loqui")
		
		var mensajesDeLoquiConDionisiaDespues= amigoService.mensajes("Loqui","DionisiaUser")
		assertFalse (mensajesDeLoquiConDionisiaDespues.isEmpty)
		assertEquals (mensajesDeLoquiConDionisiaDespues.get(0).cuerpo, mensaje.cuerpo)
		
		
		val mensaje2 = new Mensaje("Buen Dia!",LocalDateTime.now)
		amigoService.enviar("Loqui",mensaje2,"DionisiaUser")
		
		var mensajesFinalesDeLoquiConDionisia= amigoService.mensajes("Loqui","DionisiaUser")
		assertFalse (mensajesFinalesDeLoquiConDionisia.isEmpty)
		assertEquals (2,mensajesFinalesDeLoquiConDionisia.size)
	}
	
	
	def void enviarSolicitudes(){
		amigoService.mandarSolicitud("PepitaUser","DionisiaUser")
		amigoService.mandarSolicitud("Loqui","DionisiaUser")
		
		
	}
	
	def void validarIntegridadesSolicitudes(List<String> usuarios,List<Solicitud> solicitud ,Integer cantSolicitPendienteEsperada){
		
		assertEquals(cantSolicitPendienteEsperada,solicitud.size)
		usuarios.forEach[user|assertTrue(solicitud.stream.anyMatch[solicitudes| solicitudes.emisor.equals(user)])]
		assertTrue(solicitud.stream.allMatch[it.estadoDeSolicitud.equals(EstadoDeSolicitud.Pendiente)])
		
	}

	
	
	@After
	def void tearDown(){
		neo4jDao.clearAll
		new TruncateTables => [ vaciarTablas ]
	}
	
}
	
	