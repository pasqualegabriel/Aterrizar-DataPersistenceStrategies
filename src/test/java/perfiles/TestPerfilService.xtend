package perfiles

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.junit.After
import service.User
import aereolinea.Destino
import daoImplementacion.HibernateUserDAO
import service.UserService
import mailSender.EmailService
import org.mockito.Mock
import service.MailGenerator
import org.mockito.MockitoAnnotations
import service.RandomNumberGenerator
import service.ServiceHibernate
import java.util.Date
import runner.Runner
import asientoServicio.AsientoService
import asientoServicio.ReservaCompraDeAsientos
import daoImplementacion.HibernateCompraDAO
import daoImplementacion.HibernateTramoDAO
import daoImplementacion.HibernateReservaDAO
import daoImplementacion.HibernateAsientoDAO
import categorias.Turista
import java.time.LocalDateTime
import aereolinea.Asiento
import aereolinea.Tramo
import aereolinea.Vuelo
import aereolinea.Aereolinea
import service.TruncateTables
import daoImplementacion.UserNeo4jDAO
import daoImplementacion.PublicationDAO
import Excepciones.ExceptionNoVisitoDestino
import unq.amistad.AmigoService
import unq.amistad.RelacionesDeAmistades
import Excepciones.ExceptionYaExisteUnaPublicacionSobreElDestino
import daoImplementacion.ComentaryDAO
import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion

class TestPerfilService {

	User 				jose
	User 				pepita
	PerfilService 		perfilService
	HibernateUserDAO 	hibernateUserDAO
	UserService 		serviceTest
	AmigoService 		relacionesDeAmistades
	@Mock EmailService 	unMailService
	@Mock MailGenerator generatorMail
	Destino 			destino
	AsientoService 		reservaCompraDeAsientos
	HibernateAsientoDAO asientoDAO
	UserNeo4jDAO 		neo4jDao
	PublicationDAO 		publicationDAO
	ComentaryDAO 		comentaryDAO

	@Before
	def void setUp() {

		MockitoAnnotations.initMocks(this)
		publicationDAO 			= new PublicationDAO
		comentaryDAO 			= new ComentaryDAO
		hibernateUserDAO 		= new HibernateUserDAO
		neo4jDao 				= new UserNeo4jDAO
		asientoDAO 				= new HibernateAsientoDAO
		hibernateUserDAO 		= new HibernateUserDAO
		relacionesDeAmistades 	= new RelacionesDeAmistades
		serviceTest 			= new ServiceHibernate(hibernateUserDAO, generatorMail, new RandomNumberGenerator, unMailService)
		jose 					= serviceTest.singUp("Jose", "ElJose", "HunterJose", "jose@gmail.com", "password", new Date())
		pepita 					= serviceTest.singUp("Pepita", "LaGolondrina", "PepitaUser", "pepitagolondrina@gmail.com", "password", new Date())
		perfilService 			= new ProfileService(publicationDAO, comentaryDAO, hibernateUserDAO, neo4jDao)
		reservaCompraDeAsientos = new ReservaCompraDeAsientos(hibernateUserDAO, asientoDAO, new HibernateReservaDAO, new HibernateTramoDAO, new HibernateCompraDAO)
		destino 				= new Destino("Rosario")
		this.inicializarBaseDePrueba
	}

	def void inicializarBaseDePrueba() {

		var aerolinea = new Aereolinea("Aterrizar")

		val asiento = new Asiento(new Tramo(100.00, new Vuelo(aerolinea), new Destino("asdas"), destino,LocalDateTime.of(2017, 1, 10, 10, 10, 30, 00), 
				LocalDateTime.of(2017, 1, 10, 10, 19, 30, 00)),new Turista)

		val asiento2 = new Asiento(new Tramo(100.00, new Vuelo(aerolinea), new Destino("kk"), new Destino("caku"),LocalDateTime.of(2017, 1, 10, 10, 10, 30, 00), 
			    LocalDateTime.of(2017, 1, 10, 10, 19, 30, 00)),new Turista)

		Runner.runInSession [
			jose.monedero = 5000.00
			hibernateUserDAO.update(jose)
			asientoDAO.save(asiento)
			asientoDAO.save(asiento2)
			null
		]
		#[asiento, asiento2].forEach [
			reservaCompraDeAsientos.comprar(reservaCompraDeAsientos.reservar(it.id, jose.userName).id, jose.userName)
		]		
	}

	@Test
	def testUnUsuarioQueNoTeniaNingunaPublicacionAgregaUnaPublicacionSobreUnDestinoVisitado() {

		var unaPublicacionResultado = agregarPublicacionAJose(jose.userName, "Hola pepita", Visibilidad.Publico, destino)

		assertNotNull(unaPublicacionResultado.id);
	}

	@Test(expected=ExceptionYaExisteUnaPublicacionSobreElDestino)
	def testUnUsuarioConUnaPublicacionSobreUnDestinoVisitadoNoPuedeVolverAPublicarSobreDichoDestino() {

		agregarPublicacionAJose(jose.userName, "Hola pepita", Visibilidad.Publico, destino)
		agregarPublicacionAJose(jose.userName, "Hola pepita", Visibilidad.Publico, destino)
		fail()
	}

	@Test(expected=ExceptionNoVisitoDestino)
	def testUnUsuarioSinPublicacionesNoPuedePublicarSobreUnDestinoNoVisitado() {

		agregarPublicacionAJose(jose.userName, "Hola pepita", Visibilidad.Publico, new Destino("DestinoNoVisitado"))
		fail()
	}

	@Test
	def testPepitaUserAregaUnComentarioALaPublicacionPublicaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		val unComentario   = agregarComentario("PepitaUser", unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario.id));
	}
	
	@Test
	def testPepitaUserAmigoDeJoseAregaUnComentarioALaPublicacionPublicaDeHunterJose() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		val unComentario   = agregarComentario("PepitaUser", unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario.id));
	}
	
	@Test
	def testHunterJoseComentaSuPublicacionPublica() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Buen viaje", Visibilidad.Publico, destino)
		val unComentario   = agregarComentario("HunterJose", unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario.id));
	}

	@Test
	def testHunterJoseUserAregaUnComentarioASuPublicacionSoloAmigos() {

		// Exercise
		//var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.SoloAmigos, destino)
	
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.SoloAmigos, destino)
		
		perfilService.agregarPublicación(jose.userName, aPublication)
		
		val unComentario = agregarComentario(jose.userName, aPublication.id, "Alto viaje", Visibilidad.Publico)
		
		var publicacion  = publicationDAO.load(aPublication.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario.id));
	}
	
	
	@Test
	def testPepitaUserAregaUnComentarioALaPublicacionConVisibilidadSoloAmigosSuAmigoHunterJose() {
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		//var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.SoloAmigos, destino)
	
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.SoloAmigos, destino)
		
		perfilService.agregarPublicación(jose.userName, aPublication)
		
		val unComentario = agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Publico)
		
		var publicacion = publicationDAO.load(aPublication.id)
		
		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario.id))
	}
	
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testElUsuarioPepitaNoPuedeComentarLaPublicidadConVisibilidadSoloAmigosDeJosePorqueNoSonAmigos() {

		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.SoloAmigos, destino)
		
		perfilService.agregarPublicación(jose.userName, aPublication)
		
		agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Publico)

		fail
	}
	
	@Test
	def testJoseUserAgregaUnComentarioASuPropiaPublicacionConVisibilidadPrivado() {
		
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.Privado, destino)
		
		perfilService.agregarPublicación(jose.userName, aPublication)
		
		var unComentario = agregarComentario(jose.userName, aPublication.id, "Alto viaje", Visibilidad.Privado)
		
		var publicacion = publicationDAO.load(aPublication.id)
		
		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario.id))
	
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testElUsuarioPepitaNoPuedeComentarLaPublicidadConVisibilidadPrivadoDeJosePorqueNoEsElPublicador() {
		
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.Privado, destino)
		
		perfilService.agregarPublicación(jose.userName, aPublication)
		
		agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Privado)
		
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testElUsuarioPepitaAmigoDeJoseNoPuedeComentarLaPublicidadConVisibilidadPrivadoDeJosePorqueNoEsElPublicador() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.Privado, destino)
		
		perfilService.agregarPublicación(jose.userName, aPublication)
		
		agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Privado)
		
		fail
	}

	def Comentary agregarComentario(String aUserName, String idPublication, String aCampo, Visibilidad aVisibilidad) {

		var aComentary = new Comentary(aUserName, aCampo, aVisibilidad)
		perfilService.agregarComentario(idPublication, aComentary)
	}

	def Publication agregarPublicacionAJose(String aUserName, String aCampo, Visibilidad aVisibilidad, Destino unDestino) {

		var aPublication = new Publication(aUserName, aCampo, aVisibilidad, unDestino)
		perfilService.agregarPublicación(jose.userName, aPublication)
	}

	@Test
	def testPepitaUserAregaUnMeGustaALaPublicacionPublicaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioMeGusta(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnMeGustaASuPublicacionPublica() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(jose.userName, "Buen viaje", Visibilidad.Publico, destino)
		perfilService.meGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioMeGusta(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnMeGustaALaPublicacionPublicaDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioMeGusta(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnMeGustaASuPublicacionSoloAmigos() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioMeGusta(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnMeGustaALaPublicacionSoloAmigosDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioMeGusta(pepita.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnMeGustaALaPublicacionSoloAmigosDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testHunterJoseAregaUnMeGustaASuPublicacionPrivada() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.meGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioMeGusta(jose.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnMeGustaALaPublicacionPrivadaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserAmigoDeHunterJoseNoTienePermisoParaAregaUnMeGustaALaPublicacionPrivadaDeHunterJose() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testPepitaUserVuelveAAregaUnMeGustaALaPublicacionPublicaDeHunterJoseRegistrandoseSoloUnMeGustaDePepitaUser() {
		
		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioMeGusta(pepita.userName))
		assertEquals(1, publicacion.meGustan.map[ it.equals(pepita.userName) ].size)
	}

	@Test
	def testPepitaUserAregaUnNoMeGustaALaPublicacionPublicaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioNoMeGusta(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnNoMeGustaASuPublicacionPublica() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(jose.userName, "Buen viaje", Visibilidad.Publico, destino)
		perfilService.noMeGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioNoMeGusta(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnNoMeGustaALaPublicacionPublicaDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioNoMeGusta(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnNoMeGustaASuPublicacionSoloAmigos() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioNoMeGusta(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnNoMeGustaALaPublicacionSoloAmigosDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioNoMeGusta(pepita.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnNoMeGustaALaPublicacionSoloAmigosDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testHunterJoseAregaUnNoMeGustaASuPublicacionPrivada() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.noMeGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioNoMeGusta(jose.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnNoMeGustaALaPublicacionPrivadaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserAmigoDeHunterJoseNoTienePermisoParaAregaUnNoMeGustaALaPublicacionPrivadaDeHunterJose() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testPepitaUserVuelveAAregaUnNoMeGustaALaPublicacionPublicaDeHunterJoseRegistrandoseSoloUnNoMeGustaDePepitaUser() {
		
		// Exercise
		var unaPublicacion = agregarPublicacionAJose("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.leDioNoMeGusta(pepita.userName))
		assertEquals(1, publicacion.noMeGustan.map[ it.equals(pepita.userName) ].size)
	}

	@Test
	def testPepitaUserAregaUnMeGustaALaPublicacionPublicaDeHunterJoseQueTeniaUnNoMeGustaDePepitaUser() {

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		perfilService.meGusta(  pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue( publicacion.leDioMeGusta(  pepita.userName))
		assertFalse(publicacion.leDioNoMeGusta(pepita.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnNoMeGustaALaPublicacionSoloAmigosDeHunterJoseQueTeniaUnMeGustaDePepitaUser() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud( jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName, jose.userName)

		// Exercise
		var unaPublicacion = agregarPublicacionAJose(pepita.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(  pepita.userName, unaPublicacion.id)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue( publicacion.leDioNoMeGusta(pepita.userName))
		assertFalse(publicacion.leDioMeGusta(  pepita.userName))
	}


//	@Test
//	def limpiador(){
//		neo4jDao.clearAll
//		publicationDao.deleteAll
//		new TruncateTables => [ vaciarTablas ]
//		assertTrue(true)
//	}

	@After
	def void tearDown() {
		neo4jDao.clearAll
		publicationDAO.deleteAll
		new TruncateTables => [vaciarTablas]
	}

}



		