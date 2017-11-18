package amigoService

import org.junit.Test
import org.junit.Before
import static org.junit.Assert.*
import org.junit.After
import unq.amistad.RelacionesDeAmistades
import service.User
import unq.amistad.EstadoDeSolicitud
import java.util.List
import unq.amistad.Solicitud
import java.util.Date
import daoImplementacion.HibernateUserDAO
import service.TruncateTables
import java.time.format.DateTimeFormatter
import java.time.LocalDateTime
import java.time.LocalDate
import java.time.ZoneId
import unq.amistad.Mensaje
import service.ServiceHibernate
import service.UserService
import service.SimpleMailer
import service.RandomNumberGenerator
import mailSender.Postman
import daoImplementacion.UserNeo4jDAO
import unq.amistad.AmigoService

class TestAmigoService {

	AmigoService    	amigoService
	User 			  	pepita
	User 			  	dionisia
	User			  	loqui
	UserNeo4jDAO		neo4jDao
	HibernateUserDAO	userDAO
	UserService         service
	
	@Before
	def void setUp(){
		
		amigoService = new RelacionesDeAmistades
		neo4jDao     = new UserNeo4jDAO
		
		userDAO      = new HibernateUserDAO
		service      = new ServiceHibernate(userDAO, new SimpleMailer, new RandomNumberGenerator, new Postman)
		
		pepita 		 = service.singUp("Pepita", "LaGolondrina", "PepitaUser", "pepitagolondrina@gmail.com", "password", new Date())
		dionisia 	 = service.singUp("Dionisia", "LaGolondrinaVieja", "DionisiaUser", "dionisiagolondrina@gmail.com", "password", new Date())	
		loqui 		 = service.singUp("Loqui", "ElPerro", "Loqui", "perroPerrucho@gmail.com", "password", new Date())	
	}
	
	
	@Test
	def elUsuarioPepitaLeEnviaUnaSolicitudDeAmistadAlUsuarioDionisia(){
		// SetUp
		var users		= #["PepitaUser"]
		
		// Exercise
		// Se envian las solicitudes 
		amigoService.mandarSolicitud("PepitaUser","DionisiaUser")
		var solicitudes = amigoService.verSolicitudes("DionisiaUser")
		
		// Assertion
		validarIntegridadesSolicitudes(users,solicitudes,1)
	}
	
	@Test
	def elUsuarioDionisiaUserLeLlegaDosSolicitudes(){
		// SetUp
		var users		= #["Loqui", "PepitaUser"]
		
		// Exercise
		// Se envian las solicitudes 
		this.enviarSolicitudes
		
		var solicitudes = amigoService.verSolicitudes("DionisiaUser")

		
		validarIntegridadesSolicitudes(users, solicitudes, 2)
	}
	
	@Test
	def testSeRegistraUnUsuarioExitosamenteQuedandoGuardadoEnLaBaseDeDatosDeNeo4j(){
		// Exercise
		var usuario = service.singUp("Goku","Kakaroto","GokuUser","goku@gmail.com","password",new Date())
		
		var userName = neo4jDao.load(usuario)
		
		// Assertion
		
	    assertEquals(userName, "GokuUser")
	}
	
	@Test
	def elUsuarioDionisiaAceptaLaSolicitudDeLoquiLaSolicitudPasaAEstarAceptadaSeIntanciaUnaRelacionDeAmistadYAhoraTieneUnAmigoDionisia(){

		/**Antes de aceptar  una Solicitud */
		//Pepita y Loqui le envian una solicitud a Dionisia
		this.enviarSolicitudes
		var solicitudPendiente = amigoService.verSolicitudes("DionisiaUser")
		var users			   = #["Loqui", "PepitaUser"]
		assertEquals(0, amigoService.amigos("DionisiaUser").size)
		validarIntegridadesSolicitudes(users,solicitudPendiente,2)
		
		/**Despues de aceptar  una Solicitud */
		amigoService.aceptarSolicitud("DionisiaUser","Loqui");
		
		var amigosDeDionisia = amigoService.amigos("DionisiaUser");
		
		assertEquals(1, amigosDeDionisia.size)	
		assertEquals(amigosDeDionisia.get(0).userName,"Loqui");
		var solicitudPendienteDespuesDeAceptarUnaSolicitud = amigoService.verSolicitudes("DionisiaUser")
		var users2 = #["PepitaUser"]
		validarIntegridadesSolicitudes(users2,solicitudPendienteDespuesDeAceptarUnaSolicitud,1)
	}

	@Test
	def ElUsuarioDionisiaAceptaLaSolicitudDePepitaEnEl2000LaSolicitudDeLoquiEnLaActualidadYLuegoPideLosAmigosDespuesDel2001DevolviendoALoqui(){

		/**Antes de aceptar  una Solicitud */
		//Pepita y Loqui le envian una solicitud a Dionisia
		this.enviarSolicitudes
		var solicitudPendiente = amigoService.verSolicitudes("DionisiaUser")
		var users			   = #["Loqui", "PepitaUser"]
		assertEquals(0, amigoService.amigos("DionisiaUser").size)
		validarIntegridadesSolicitudes(users,solicitudPendiente,2)
		
		/**Despues de aceptar  una Solicitud */
		amigoService.aceptarSolicitud("DionisiaUser","Loqui");
		
		var fecha 			= "09/10/2000"
		var formatter		= DateTimeFormatter.ofPattern("MM/dd/yyyy");
		var zoneId 			= ZoneId.systemDefault();
		var fechaformated 	= LocalDateTime.from(LocalDate.parse(fecha, formatter).atStartOfDay()).atZone(zoneId).toEpochSecond();
		
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
		
		//Exercise
		
		/**  Antes de enviar un mensaje */
		amigoService.mandarSolicitud("Loqui"        , "DionisiaUser")
		amigoService.aceptarSolicitud("DionisiaUser", "Loqui")
		
		var mensajesDeLoquiConDionisiaAntes= amigoService.mensajes("Loqui","DionisiaUser")
		
		assertTrue (mensajesDeLoquiConDionisiaAntes.isEmpty)
		
		/**  Se envia un mensaje de Dionisia a Loqui */
		
		val mensaje = new Mensaje("Hola!",LocalDateTime.now)
		
		amigoService.enviar("DionisiaUser",mensaje,"Loqui")
		
		// Assertion
		
		var mensajesDeLoquiConDionisiaDespues= amigoService.mensajes("Loqui","DionisiaUser")
		assertFalse (mensajesDeLoquiConDionisiaDespues.isEmpty)
		assertEquals (mensajesDeLoquiConDionisiaDespues.get(0).cuerpo, mensaje.cuerpo)
		
		/**  Se envia un mensaje de Loqui a Dionisia */
		
		// Exercise
		
		val mensaje2 = new Mensaje("Buen Dia!",LocalDateTime.now)
		amigoService.enviar("Loqui",mensaje2,"DionisiaUser")
		
		// Assertion
		
		var mensajesFinalesDeLoquiConDionisia= amigoService.mensajes("Loqui","DionisiaUser")
		assertFalse (mensajesFinalesDeLoquiConDionisia.isEmpty)
		assertEquals (2,mensajesFinalesDeLoquiConDionisia.size)
	}
	
	/** Dada una Lista de usuarios, una lista de solicitudes, y un numero; verifica que esos usuarios, mandaron esas solicitudes
	 *  y de ellas la cantidad que estan en estado pendiente son ese numero*/
	def void validarIntegridadesSolicitudes(List<String> usuarios, List<Solicitud> solicitud, Integer cantSolicitPendienteEsperada){
		
		assertEquals(cantSolicitPendienteEsperada,solicitud.size)
		usuarios.forEach[user|assertTrue(solicitud.stream.anyMatch[ solicitudes | solicitudes.emisor.equals(user)])]
		assertTrue(solicitud.stream.allMatch[it.estadoDeSolicitud.equals(EstadoDeSolicitud.Pendiente)])
	}
	
	@Test
	def void testConectados(){
		// SetUp
		// Se generan las amistades
		amistades
		
		// Exercise
		var usuarios = amigoService.conectados("PepitaUser")
		
		// Assertion
		assertEquals(8, usuarios.size)
		assertTrue(true)
	}

	/**  Pepita y Loqui le envian una solicitud de Amistad A Dionisia */
	def void enviarSolicitudes(){
		amigoService.mandarSolicitud("PepitaUser","DionisiaUser")
		amigoService.mandarSolicitud("Loqui","DionisiaUser")
	}
	
	/**  Se genera el grafo de amistades entre los usuarios */
	def void amistades(){
		
		service.singUp("a", "n", "Odin"   ,  "o@gmail.com", "password", new Date())	
		service.singUp("b", "m", "Perrito",  "p@gmail.com", "password", new Date())	
		service.singUp("c", "l", "Maximo" ,  "q@gmail.com", "password", new Date())	
		service.singUp("d", "k", "Bandido",  "r@gmail.com", "password", new Date())	
	    service.singUp("e", "j", "Cloyoe" ,  "s@gmail.com", "password", new Date())	
		service.singUp("f", "i", "Alegro" ,  "t@gmail.com", "password", new Date())	
		service.singUp("g", "h", "Pepon"  ,  "u@gmail.com", "password", new Date())	
		
		
		amigoService.mandarSolicitud("PepitaUser"	, "DionisiaUser")
		amigoService.mandarSolicitud("DionisiaUser"	, "Perrito")
		amigoService.mandarSolicitud("DionisiaUser"	, "Loqui")
		amigoService.mandarSolicitud("Perrito"		, "Maximo")
		amigoService.mandarSolicitud("Perrito"		, "Loqui")
		amigoService.mandarSolicitud("Loqui"		, "Odin")
		amigoService.mandarSolicitud("Loqui"		, "Bandido")
		amigoService.mandarSolicitud("Maximo"		, "Odin")
		amigoService.mandarSolicitud("Bandido"		, "Alegro")
		amigoService.mandarSolicitud("Alegro"		, "Cloyoe")
		
		amigoService.aceptarSolicitud("DionisiaUser", "PepitaUser")
		amigoService.aceptarSolicitud("Perrito"		, "DionisiaUser")
		amigoService.aceptarSolicitud("Loqui"		, "DionisiaUser")
		amigoService.aceptarSolicitud("Maximo"		, "Perrito")
		amigoService.aceptarSolicitud("Loqui"		, "Perrito")
		amigoService.aceptarSolicitud("Odin"		, "Loqui")
		amigoService.aceptarSolicitud("Bandido"		, "Loqui")
		amigoService.aceptarSolicitud("Odin"		, "Maximo")
		amigoService.aceptarSolicitud("Alegro"		, "Bandido")
		amigoService.aceptarSolicitud("Cloyoe"		, "Alegro")
	}
	
	@After
	def void tearDown(){
		neo4jDao.clearAll
		new TruncateTables => [ vaciarTablas ]
	}
	
}



