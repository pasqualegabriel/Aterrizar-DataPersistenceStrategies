package cacheDePerfil



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
import unq.amistad.AmigoService
import unq.amistad.RelacionesDeAmistades
import perfiles.PerfilService
import perfiles.ProfileService
import perfiles.Comentary
import perfiles.Publication
import perfiles.Visibilidad
import perfiles.Profile
import java.util.stream.Collectors

class TestCacheDePerfilRedis {
	
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
	CacheDePerfil		cache
	Profile				perfilDeJosePublico
	Profile				perfilDeJoseSoloAmigos
	
	KeyDeCacheDePerfil  keyJoseJose
	KeyDeCacheDePerfil  keyJosePepita
	
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
		cache                   = new CacheDePerfil(100 * 60)
		perfilService 			= new ProfileService(publicationDAO, hibernateUserDAO, cache)
		reservaCompraDeAsientos = new ReservaCompraDeAsientos(hibernateUserDAO, asientoDAO, new HibernateReservaDAO, new HibernateTramoDAO, new HibernateCompraDAO)
		destino 				= new Destino("Rosario")
		destino2 				= new Destino("Fuerte Apache")
		destino3				= new Destino("La Plato")
		
		this.inicializarBaseDePrueba

        this.perfilDeJosePublico 	 = perfilService.verPerfil(dionisia.userName,jose.userName)
        this.perfilDeJoseSoloAmigos  =  perfilService.verPerfil(pepita.userName,jose.userName);
        
        keyJoseJose   = new KeyDeCacheDePerfil(jose.userName, jose.userName);
        keyJosePepita = new KeyDeCacheDePerfil(pepita.userName,jose.userName);

      
		
		
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
		
		/** creando relacion de amistad entre jose y pepita */
		relacionesDeAmistades.mandarSolicitud(jose.userName,   pepita.userName)
		relacionesDeAmistades.aceptarSolicitud(pepita.userName,jose.userName)
		
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
		
		
		
	}
	
	
	@Test
	def void testAlGuardarYLuegoRecuperarAlUsuarioSeObtienenObjetosSimilares() {
		this.cache.put(keyJoseJose, perfilDeJosePublico)
        this.cache.put(keyJosePepita, perfilDeJoseSoloAmigos)
		
		var profileResultado  = this.cache.get(keyJoseJose)
		var profileResultado2 = this.cache.get(keyJosePepita)
		
		assertTrue(profileResultado.publications.stream.map[it.id].collect(Collectors.toList()).containsAll(perfilDeJosePublico    .publications.stream.map[it.id].collect(Collectors.toList()) ))
		assertTrue(profileResultado2.publications.stream.map[it.id].collect(Collectors.toList()).containsAll(perfilDeJoseSoloAmigos.publications.stream.map[it.id].collect(Collectors.toList()) ))
	
		
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
		this.cache.clear();
	}

	
	
}