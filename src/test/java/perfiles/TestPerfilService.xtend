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
import Excepciones.ExceptionNoTienePermisoParaInteractuarConLaPublicacion
import Excepciones.ExceptionNoTienePermisoParaInteractuarConElComentario

class TestPerfilService {

	User 				jose
	User 				pepita
	User 				dionisia
	PerfilService 		perfilService
	HibernateUserDAO 	hibernateUserDAO
	UserService 		serviceTest
	AmigoService 		relacionesDeAmistades
	@Mock EmailService 	unMailService
	@Mock MailGenerator generatorMail
	Destino 			destino
	Destino				destino2
	Destino				destino3
	AsientoService 		reservaCompraDeAsientos
	HibernateAsientoDAO asientoDAO
	UserNeo4jDAO 		neo4jDao
	PublicationDAO 		publicationDAO
	Aereolinea          aerolinea

	@Before
	def void setUp() {
		
		MockitoAnnotations.initMocks(this)
		
		publicationDAO 			= new PublicationDAO
		hibernateUserDAO 		= new HibernateUserDAO
		neo4jDao 				= new UserNeo4jDAO
		asientoDAO 				= new HibernateAsientoDAO
		hibernateUserDAO 		= new HibernateUserDAO
		relacionesDeAmistades 	= new RelacionesDeAmistades
		serviceTest 			= new ServiceHibernate(hibernateUserDAO, generatorMail, new RandomNumberGenerator, unMailService)
		jose 					= serviceTest.singUp("Jose", "ElJose", "HunterJose", "jose@gmail.com", "password", new Date())
		pepita 					= serviceTest.singUp("Pepita", "LaGolondrina", "PepitaUser", "pepitagolondrina@gmail.com", "password", new Date())
		dionisia 				= serviceTest.singUp("Dionisia", "LaGolondrinaVieja", "DionisiaUser", "dionisia@gmail.com", "password", new Date())
		perfilService 			= new ProfileService(publicationDAO, hibernateUserDAO)
		reservaCompraDeAsientos = new ReservaCompraDeAsientos(hibernateUserDAO, asientoDAO, new HibernateReservaDAO, new HibernateTramoDAO, new HibernateCompraDAO)
		destino 				= new Destino("Rosario")
		destino2 				= new Destino("Fuerte Apache")
		destino3				= new Destino("La Plato")
		
		this.inicializarBaseDePrueba
	}

	def void inicializarBaseDePrueba() {

		aerolinea = new Aereolinea("Aterrizar")

		val asiento = new Asiento(new Tramo(100.00, new Vuelo(aerolinea), new Destino("asdas"), destino,LocalDateTime.of(2017, 1, 10, 10, 10, 30, 00), 
				LocalDateTime.of(2017, 1, 10, 10, 19, 30, 00)),new Turista)

		val asiento2 = new Asiento(new Tramo(100.00, new Vuelo(aerolinea), new Destino("vegeta"), destino2,LocalDateTime.of(2017, 1, 10, 10, 10, 30, 00), 
			    LocalDateTime.of(2017, 1, 10, 10, 19, 30, 00)),new Turista)
		
		val asiento3 = new Asiento(new Tramo(100.00, new Vuelo(aerolinea), new Destino("kakaroto"), destino3,LocalDateTime.of(2017, 1, 10, 10, 10, 30, 00), 
			    LocalDateTime.of(2017, 1, 10, 10, 19, 30, 00)),new Turista)

		Runner.runInSession [
			jose.monedero = 5000.00
			hibernateUserDAO.update(jose)
			asientoDAO.save(asiento)
			asientoDAO.save(asiento2)
			asientoDAO.save(asiento3)
			null
		]
		
		#[asiento, asiento2,asiento3].forEach [
			reservaCompraDeAsientos.comprar(reservaCompraDeAsientos.reservar(it.id, jose.userName).id, jose.userName)
		]		
	}

	@Test
	def testUnUsuarioQueNoTeniaNingunaPublicacionAgregaUnaPublicacionSobreUnDestinoVisitado() {

		var unaPublicacionResultado = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Publico, destino)

		assertNotNull(unaPublicacionResultado.id);
	}

	@Test(expected=ExceptionYaExisteUnaPublicacionSobreElDestino)
	def testUnUsuarioConUnaPublicacionSobreUnDestinoVisitadoNoPuedeVolverAPublicarSobreDichoDestino() {

		agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Publico, destino)
		agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Publico, destino)
		fail()
	}

	@Test(expected=ExceptionNoVisitoDestino)
	def testUnUsuarioSinPublicacionesNoPuedePublicarSobreUnDestinoNoVisitado() {

		agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Publico, new Destino("DestinoNoVisitado"))
		fail()
	}

	@Test
	def testPepitaUserAregaUnComentarioALaPublicacionPublicaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		val unComentario   = agregarComentario("PepitaUser", unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario));
	}
	
	@Test
	def testPepitaUserAmigoDeJoseAregaUnComentarioALaPublicacionPublicaDeHunterJose() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		val unComentario   = agregarComentario("PepitaUser", unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario));
	}
	
	@Test
	def testHunterJoseComentaSuPublicacionPublica() {

		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Buen viaje", Visibilidad.Publico, destino)
		val unComentario   = agregarComentario("HunterJose", unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario));
	}

	@Test
	def testHunterJoseUserAregaUnComentarioASuPublicacionSoloAmigos() {

		// Exercise
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.SoloAmigos, destino)
		
		perfilService.agregarPublicación(aPublication)
		
		val unComentario = agregarComentario(jose.userName, aPublication.id, "Alto viaje", Visibilidad.Publico)
		
		var publicacion  = publicationDAO.load(aPublication.id)

		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario));
	}
	
	
	@Test
	def testPepitaUserAregaUnComentarioALaPublicacionConVisibilidadSoloAmigosDeSuAmigoHunterJose() {
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud( jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		//var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.SoloAmigos, destino)
	
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.SoloAmigos, destino)
		
		perfilService.agregarPublicación(aPublication)
		
		val unComentario = agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Publico)
		
		var publicacion = publicationDAO.load(aPublication.id)
		
		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario))
	}
	
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testElUsuarioPepitaNoPuedeComentarLaPublicacionConVisibilidadSoloAmigosDeJosePorqueNoSonAmigos() {

		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.SoloAmigos, destino)
		
		perfilService.agregarPublicación(aPublication)
		
		agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Publico)

		fail
	}
	
	@Test
	def testJoseUserAgregaUnComentarioASuPropiaPublicacionConVisibilidadPrivado() {
		
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.Privado, destino)
		
		perfilService.agregarPublicación(aPublication)
		
		var unComentario = agregarComentario(jose.userName, aPublication.id, "Alto viaje", Visibilidad.Privado)
		
		var publicacion = publicationDAO.load(aPublication.id)
		
		// Assertion
		assertTrue(publicacion.hasCommentary(unComentario))
	
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testElUsuarioPepitaNoPuedeComentarLaPublicidadConVisibilidadPrivadoDeJosePorqueNoEsElPublicador() {
		
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.Privado, destino)
		
		perfilService.agregarPublicación(aPublication)
		
		agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Privado)
		
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testElUsuarioPepitaAmigoDeJoseNoPuedeComentarLaPublicidadConVisibilidadPrivadoDeJosePorqueNoEsElPublicador() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		var aPublication = new Publication(jose.userName, "unCampo", Visibilidad.Privado, destino)
		
		perfilService.agregarPublicación(aPublication)
		
		agregarComentario(pepita.userName, aPublication.id, "Alto viaje", Visibilidad.Privado)
		
		fail
	}


	@Test
	def testPepitaUserAregaUnMeGustaALaPublicacionPublicaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnMeGustaASuPublicacionPublica() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Publico, destino)
		perfilService.meGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnMeGustaALaPublicacionPublicaDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnMeGustaASuPublicacionSoloAmigos() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnMeGustaALaPublicacionSoloAmigosDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(pepita.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnMeGustaALaPublicacionSoloAmigosDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testHunterJoseAregaUnMeGustaASuPublicacionPrivada() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.meGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(jose.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnMeGustaALaPublicacionPrivadaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserAmigoDeHunterJoseNoTienePermisoParaAregaUnMeGustaALaPublicacionPrivadaDeHunterJose() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testPepitaUserVuelveAAregaUnMeGustaALaPublicacionPublicaDeHunterJoseRegistrandoseSoloUnMeGustaDePepitaUser() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)
		perfilService.meGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(pepita.userName))
		assertEquals(1, publicacion.meGustan.map[ it.equals(pepita.userName) ].size)
	}

	@Test
	def testPepitaUserAregaUnNoMeGustaALaPublicacionPublicaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.noMeGustan.contains(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnNoMeGustaASuPublicacionPublica() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Publico, destino)
		perfilService.noMeGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.noMeGustan.contains(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnNoMeGustaALaPublicacionPublicaDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.noMeGustan.contains(pepita.userName))
	}
	
	@Test
	def testHunterJoseAregaUnNoMeGustaASuPublicacionSoloAmigos() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.noMeGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.noMeGustan.contains(jose.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnNoMeGustaALaPublicacionSoloAmigosDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.noMeGustan.contains(pepita.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnNoMeGustaALaPublicacionSoloAmigosDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testHunterJoseAregaUnNoMeGustaASuPublicacionPrivada() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.noMeGusta(jose.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.noMeGustan.contains(jose.userName))
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserNoTienePermisoParaAregaUnNoMeGustaALaPublicacionPrivadaDeHunterJose() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConLaPublicacion)
	def testPepitaUserAmigoDeHunterJoseNoTienePermisoParaAregaUnNoMeGustaALaPublicacionPrivadaDeHunterJose() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Privado, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		fail
	}
	
	@Test
	def testPepitaUserVuelveAAregaUnNoMeGustaALaPublicacionPublicaDeHunterJoseRegistrandoseSoloUnNoMeGustaDePepitaUser() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion("HunterJose", "Hola pepita", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.noMeGustan.contains(pepita.userName))
		assertEquals(1, publicacion.noMeGustan.map[ it.equals(pepita.userName) ].size)
	}

	@Test
	def testPepitaUserAregaUnMeGustaALaPublicacionPublicaDeHunterJoseQueTeniaUnNoMeGustaDePepitaUser() {

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.Publico, destino)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)
		perfilService.meGusta(  pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.meGustan.contains(  pepita.userName))
		assertFalse(publicacion.noMeGustan.contains(pepita.userName))
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAregaUnNoMeGustaALaPublicacionSoloAmigosDeHunterJoseQueTeniaUnMeGustaDePepitaUser() {

		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud( jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName, jose.userName)

		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Buen viaje", Visibilidad.SoloAmigos, destino)
		perfilService.meGusta(  pepita.userName, unaPublicacion.id)
		perfilService.noMeGusta(pepita.userName, unaPublicacion.id)

		var publicacion = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue( publicacion.noMeGustan.contains(pepita.userName))
		assertFalse(publicacion.meGustan.contains(  pepita.userName))
	}
	
	/**TEST ME GUSTA A COMENTARIO CON TODAS SUS VISIBILIDADES */
	@Test
	def testPepitaUserAgregaUnMeGustaAUnComentarioPublicoDeHunterJose() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Publico, destino)
		var unComentario   = agregarComentario(pepita.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		perfilService.meGusta(dionisia.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario | comentario.meGustan.contains(dionisia.userName)]);
	}
	
	@Test
	def testHunterJoseAgregaUnMeGustaASuPropioComentarioConVisibilidadSoloAmigos() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.SoloAmigos, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.SoloAmigos)

		perfilService.meGusta(jose.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario | comentario.meGustan.contains(jose.userName)]);
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAgregaUnMeGustaAElComentarioConVisibilidadSoloAmigosDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.SoloAmigos, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.SoloAmigos)

		perfilService.meGusta(pepita.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario | comentario.meGustan.contains(pepita.userName)]);
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConElComentario)
	def testPepitaUserAgregaUnMeGustaAElComentarioConVisibilidadSoloAmigosDeHunterJose() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.SoloAmigos, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.SoloAmigos)

		perfilService.meGusta(pepita.userName, unComentario.id)
		fail
	}
	
	@Test
	def testHunterJoseAgregaUnMeGustaASuPropioComentarioConVisibilidadPrivado() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Privado, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Privado)

		perfilService.meGusta(jose.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario |  comentario.meGustan.contains(jose.userName)]);
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConElComentario)
	def testPepitaUserAmigoDeHunterJoseNoPuedeAgregarUnMeGustaAElComentarioConVisibilidadPrivadaDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Privado, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Privado)

		perfilService.meGusta(pepita.userName, unComentario.id)
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConElComentario)
	def testPepitaUserAgregaUnMeGustaAElComentarioConVisibilidadPrivadaDeHunterJose() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Privado, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Privado)

		perfilService.meGusta(pepita.userName, unComentario.id)
		fail
	}
	
/**TEST NO ME GUSTA A COMENTARIO CON TODAS SUS VISIBILIDADES */
	@Test
	def testPepitaUserAgregaUnNoMeGustaAUnComentarioPublicoDeHunterJose() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Publico, destino)
		var unComentario   = agregarComentario(pepita.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Publico)

		perfilService.noMeGusta(dionisia.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario |  comentario.noMeGustan.contains(dionisia.userName)]);
	}
	
	@Test
	def testHunterJoseAgregaUnNoMeGustaASuPropioComentarioConVisibilidadSoloAmigos() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.SoloAmigos, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.SoloAmigos)

		perfilService.noMeGusta(jose.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario |  comentario.noMeGustan.contains(jose.userName)]);
	}
	
	@Test
	def testPepitaUserAmigoDeHunterJoseAgregaUnNoMeGustaAElComentarioConVisibilidadSoloAmigosDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.SoloAmigos, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.SoloAmigos)

		perfilService.noMeGusta(pepita.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario | comentario.noMeGustan.contains(pepita.userName)]);
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConElComentario)
	def testPepitaUserAgregaUnNoMeGustaAElComentarioConVisibilidadSoloAmigosDeHunterJose() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.SoloAmigos, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.SoloAmigos)

		perfilService.noMeGusta(pepita.userName, unComentario.id)
		fail
	}
	
	@Test
	def testHunterJoseAgregaUnNoMeGustaASuPropioComentarioConVisibilidadPrivado() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Privado, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Privado)

		perfilService.noMeGusta(jose.userName, unComentario.id)

		var publicacion    = publicationDAO.load(unaPublicacion.id)

		// Assertion
		assertTrue(publicacion.comentarios.stream.anyMatch[comentario | comentario.noMeGustan.contains(jose.userName)]);
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConElComentario)
	def testPepitaUserAmigoDeHunterJoseNoPuedeAgregarUnNoMeGustaAElComentarioConVisibilidadPrivadaDeHunterJose() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Privado, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Privado)

		perfilService.noMeGusta(pepita.userName, unComentario.id)
		fail
	}
	
	@Test(expected=ExceptionNoTienePermisoParaInteractuarConElComentario)
	def testPepitaUserAgregaUnNoMeGustaAElComentarioConVisibilidadPrivadaDeHunterJose() {
		
		// Exercise
		var unaPublicacion = agregarPublicacion(jose.userName, "Hola pepita", Visibilidad.Privado, destino)
		var unComentario   = agregarComentario(jose.userName, unaPublicacion.id, "Alto viaje", Visibilidad.Privado)

		perfilService.noMeGusta(pepita.userName, unComentario.id)
		fail
	}
	
	
	@Test
	def joseVeSus3PublicacionesY3ComentariosConDiferentesVisibilidadesPeroNoElComentarioPrivadoDePepita() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		agregarPublicacionesYComentariosDeJoseYPepita()
	
		var perfil = perfilService.verPerfil(jose.userName, jose.userName)
		
		assertEquals(3, perfil.publications.size)
		assertTrue(perfil.publications.stream.allMatch[it.comentarios.size.equals(3)])
	}

	@Test
	def pepiptaQueNoEsAmigaDeJoseVeLaUnicaPublicacionPublicaConElMensajePublicoYElSuyoPrivado() {
		
		agregarPublicacionesYComentariosDeJoseYPepita()
		
		var perfil = perfilService.verPerfil(pepita.userName, jose.userName)
		
		assertEquals(1,perfil.publications.size )
		assertTrue(perfil.publications.stream.allMatch[it.comentarios.size.equals(2)])
		
	}
	
	@Test
	def  pepiptaQueEsAmigaDeJoseVeLasPublicacionesNoPrivadasConLosMensajesNoPrivadosYElSuyoPrivado() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		agregarPublicacionesYComentariosDeJoseYPepita()
		
		
		var perfil = perfilService.verPerfil(pepita.userName,jose.userName)
		
		assertEquals(perfil.publications.size,2 )
		assertTrue(perfil.publications.stream.anyMatch[it.comentarios.size.equals(3)])
		assertTrue(perfil.publications.stream.anyMatch[it.comentarios.size.equals(2)])
		
	}
	
	@Test
	def  pepiptaQueEsAmigaDeJoseVeLasPublicacionesNoPrivadasConLosMensajesNoPrivadosYElSuyoPrivadoYNoVeLaPublicacionDeDionisia() {
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
		agregarPublicacionesYComentariosDeJoseYPepita()
		var destinoA = new Destino("Roma")
		var destinoB = new Destino("Madrid")
		val unAsientoA = new Asiento(new Tramo(100.00, new Vuelo(aerolinea), destinoA, destinoA, LocalDateTime.of(2017, 1, 10, 10, 10, 30, 00), 
				LocalDateTime.of(2017, 1, 10, 10, 19, 30, 00)),new Turista)
		val unAsientoB = new Asiento(new Tramo(100.00, new Vuelo(aerolinea), destinoB, destinoB, LocalDateTime.of(2017, 1, 10, 10, 10, 30, 00), 
				LocalDateTime.of(2017, 1, 10, 10, 19, 30, 00)),new Turista)
		Runner.runInSession [
			dionisia.monedero = 5000.00
			hibernateUserDAO.update(dionisia)
			pepita.monedero = 5000.00
			hibernateUserDAO.update(pepita)
			asientoDAO.save(unAsientoA)
			asientoDAO.save(unAsientoB)
			null
		]
		reservaCompraDeAsientos.comprar(reservaCompraDeAsientos.reservar(unAsientoA.id, dionisia.userName).id, dionisia.userName)
		reservaCompraDeAsientos.comprar(reservaCompraDeAsientos.reservar(unAsientoB.id, pepita.userName).id,   pepita.userName)
		var aPublicationA = agregarPublicacion(dionisia.userName, "hola pepita", Visibilidad.Publico , destinoA)
		agregarComentario  	 (jose.userName, aPublicationA.id, "gran viajeA", Visibilidad.Publico)
		var aPublicationB = agregarPublicacion(pepita.userName, "hola pepita", Visibilidad.Publico , destinoB)
		agregarComentario  	 (pepita.userName, aPublicationB.id, "gran viajeB", Visibilidad.Publico)
		
		var perfil = perfilService.verPerfil(pepita.userName,jose.userName)
		
		assertEquals(perfil.publications.size,2 )
		assertTrue(perfil.publications.stream.anyMatch[it.comentarios.size.equals(3)])
		assertTrue(perfil.publications.stream.anyMatch[it.comentarios.size.equals(2)])
		
	}
	
	def agregarPublicacionesYComentariosDeJoseYPepita() {
		var unaPublicacion1 = agregarPublicacion(jose.userName, "Hola pepita"      , Visibilidad.Privado   , destino )
		var unaPublicacion2 = agregarPublicacion(jose.userName, "Como andas pepita", Visibilidad.SoloAmigos, destino2)	
		var unaPublicacion3 = agregarPublicacion(jose.userName, "Chau pepita"      , Visibilidad.Publico   , destino3)
		
		agregarComentario(jose.userName, unaPublicacion1.id, "Alto viaje1", Visibilidad.Privado)
		agregarComentario(jose.userName, unaPublicacion1.id, "Alto viaje2", Visibilidad.SoloAmigos)
		agregarComentario(jose.userName, unaPublicacion1.id, "Alto viaje3", Visibilidad.Publico)
		
		agregarComentario(jose.userName, unaPublicacion2.id, "Alto viaje4", Visibilidad.Privado)
		agregarComentario(jose.userName, unaPublicacion2.id, "Alto viaje5", Visibilidad.SoloAmigos)
		agregarComentario(jose.userName, unaPublicacion2.id, "Alto viaje6", Visibilidad.Publico)
		
		agregarComentario(jose.userName, unaPublicacion3.id, "Alto viaje7", Visibilidad.Privado)
		agregarComentario(jose.userName, unaPublicacion3.id, "Alto viaje8", Visibilidad.SoloAmigos)
		agregarComentario(jose.userName, unaPublicacion3.id, "Alto viaje9", Visibilidad.Publico)
		
		agregarComentario(pepita.userName,unaPublicacion3.id,"Alto viaje0", Visibilidad.Privado)
	}
	
	
	def Comentary agregarComentario(String aUserName, String idPublication, String aCampo, Visibilidad aVisibilidad) {

		var aComentary = new Comentary(aUserName, aCampo, aVisibilidad)
		perfilService.agregarComentario(idPublication, aComentary)
	}

	def Publication agregarPublicacion(String aUserName, String aCampo, Visibilidad aVisibilidad, Destino unDestino) {

		var aPublication = new Publication(aUserName, aCampo, aVisibilidad, unDestino)
		perfilService.agregarPublicación(aPublication)
	}


	@After
	def void tearDown() {
		neo4jDao.clearAll
		publicationDAO.deleteAll
		new TruncateTables => [vaciarTablas]
	}

}



		