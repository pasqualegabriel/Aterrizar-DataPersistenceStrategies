package amigoService

import org.junit.Test
import org.junit.Before
import static org.junit.Assert.*
import org.junit.After
import unq.amistad.RelacionesDeAmistades
import service.User
import daoImplementacion.Neo4jDAO
import unq.amistad.EstadoDeSolicitud
import java.util.List
import unq.amistad.Solicitud
import runner.Runner
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
import dao.UserDAO
import service.SimpleMailer
import service.RandomNumberGenerator
import mailSender.Postman

class TestAmigoService {

	RelacionesDeAmistades 	amigoService
	User 				  	pepita
	User 				  	dionisia
	User				  	loqui
	Neo4jDAO				neo4jDao
	UserDAO 			    userDAO
	UserService             service
	
	@Before
	def void setUp(){
		
		amigoService = new RelacionesDeAmistades
		neo4jDao     = new Neo4jDAO
		
		userDAO      = new HibernateUserDAO
		service      = new ServiceHibernate(userDAO, new SimpleMailer, new RandomNumberGenerator, new Postman)
		
		pepita 		 = new User("Pepita", "LaGolondrina", "PepitaUser", "pepitagolondrina@gmail.com", "password", new Date())
		dionisia 	 = new User("Dionisia", "LaGolondrinaVieja", "DionisiaUser", "dionisiagolondrina@gmail.com", "password", new Date())	
		loqui 		 = new User("Loqui", "ElPerro", "Loqui", "perroPerrucho@gmail.com", "password", new Date())	
		val usuarios = #[pepita, dionisia, loqui]
		Runner.runInSession[
			usuarios.forEach[
				userDAO.save(it)
				neo4jDao.save(it)
			]
			null
		]
	}
	
//	@Test
//	def tirarBase(){
//		assertTrue(true)
//	}
	
	@Test
	def elUsuarioPepitaLeEnviaUnaSolicitudDeAmistadAlUsuarioDionisia(){
		amigoService.mandarSolicitud("PepitaUser","DionisiaUser")
		var solicitudes = amigoService.verSolicitudes("DionisiaUser")
		var users		= #["PepitaUser"]
		validarIntegridadesSolicitudes(users,solicitudes,1)
	}
	
	@Test
	def elUsuarioDionisiaUserLeLlegaDosSolicitudes(){
		this.enviarSolicitudes
		var solicitudes = amigoService.verSolicitudes("DionisiaUser")
		var users		= #["Loqui", "PepitaUser"]
		
		validarIntegridadesSolicitudes(users, solicitudes, 2)
	}
	
	@Test
	def testSeRegistraUnUsuarioExitosamenteQuedandoGuardadoEnLaBaseDeDatosDeNeo4j(){

		var usuario = service.singUp("Goku","Kakaroto","GokuUser","goku@gmail.com","password",new Date())
		
		var userName = neo4jDao.load(usuario)
		
	    assertEquals(userName, "GokuUser")
	}
	
	@Test
	def elUsuarioDionisiaAceptaLaSolicitudDeLoquiLaSolicitudPasaAEstarAceptadaSeIntanciaUnaRelacionDeAmistadYAhoraTieneUnAmigoDionisia(){

		/**Antes de aceptar  una Solicitud */
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

		amigoService.mandarSolicitud("Loqui"        , "DionisiaUser")
		amigoService.aceptarSolicitud("DionisiaUser", "Loqui");
		
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
	
	def void validarIntegridadesSolicitudes(List<String> usuarios, List<Solicitud> solicitud, Integer cantSolicitPendienteEsperada){
		
		assertEquals(cantSolicitPendienteEsperada,solicitud.size)
		usuarios.forEach[user|assertTrue(solicitud.stream.anyMatch[ solicitudes | solicitudes.emisor.equals(user)])]
		assertTrue(solicitud.stream.allMatch[it.estadoDeSolicitud.equals(EstadoDeSolicitud.Pendiente)])
	}
	
	@Test
	def void testConectados(){
		amistades
		var usuarios = amigoService.conectados("PepitaUser")
		
		assertEquals(9, usuarios.size)
		assertTrue(true)
	}

	def void enviarSolicitudes(){
		amigoService.mandarSolicitud("PepitaUser","DionisiaUser")
		amigoService.mandarSolicitud("Loqui","DionisiaUser")
	}
	
	def void amistades(){
		
		//PepitaUser, DionisiaUser, Loqui
		var odin	= new User("Odin")
		var perrito = new User("Perrito")
		var maximo 	= new User("Maximo")
		var bandido = new User("Bandido")
		var cloyoe 	= new User("Cloyoe")
		var alegro 	= new User("Alegro")
		var pepon 	= new User("Pepon")
		
		val users 	= #[odin, perrito, maximo, bandido, cloyoe, alegro, pepon]
		
		Runner.runInSession[
			users.forEach[
				userDAO.save(it)
				neo4jDao.save(it)
			]
			null
		]

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



