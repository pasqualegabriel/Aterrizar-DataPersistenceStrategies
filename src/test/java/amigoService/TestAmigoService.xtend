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
	def elUsuarioDionisiaAceptaLaSolicitudDeLoquiLaSolicitudPasaAEstarAceptadaYSeIntanciaUnaRelacionDeAmistadYAhoraTieneUnAmigoDionisia(){
		val userDAO = new HibernateUserDAO
		pepita = new User("Pepita", "LaGolondrina", "PepitaUser", "pepitagolondrina@gmail.com", "password", new Date())
		dionisia = new User("Pepita", "LaGolondrina", "DionisiaUser", "pepitagolondrina@gmail.com", "password", new Date())	
		loqui = new User("Pepita", "LaGolondrina", "Loqui", "pepitagolondrina@gmail.com", "password", new Date())	
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
		assertEquals(1, amigoService.amigos("DionisiaUser").size)
		var solicitudPendienteDespuesDeAceptarUnaSolicitud = amigoService.verSolicitudes("DionisiaUser")
		var users2		   = #["PepitaUser"]
		validarIntegridadesSolicitudes(users2,solicitudPendienteDespuesDeAceptarUnaSolicitud,1)
		
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
	
	