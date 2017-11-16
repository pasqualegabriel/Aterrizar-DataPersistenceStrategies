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

class TestPerfilService {
	
	User 				usuario
	PerfilService 		perfilService
	HibernateUserDAO 	hibernateUserDAO
	UserService 		serviceTest
	@Mock EmailService  unMailService
	@Mock MailGenerator generatorMail
	Destino 			destino
	AsientoService 		reservaCompraDeAsientos
	HibernateAsientoDAO asientoDAO
	UserNeo4jDAO		neo4jDao
	PublicationDAO 		publicationDao
	
	@Before
	def void setUp(){
		
		MockitoAnnotations.initMocks(this)
		publicationDao		= new PublicationDAO
		hibernateUserDAO 	= new HibernateUserDAO
		neo4jDao            = new UserNeo4jDAO
		asientoDAO          = new HibernateAsientoDAO
        hibernateUserDAO    = new HibernateUserDAO
		serviceTest   		= new ServiceHibernate(hibernateUserDAO, generatorMail, new RandomNumberGenerator, unMailService)
		usuario      	 	= serviceTest.singUp("Pepita","LaGolondrina","HunterJose","pepitagolondrina@gmail.com", "password",new Date())
		perfilService 		= new Xxxx(publicationDao,hibernateUserDAO)
		reservaCompraDeAsientos = new ReservaCompraDeAsientos(hibernateUserDAO, asientoDAO, new HibernateReservaDAO, new HibernateTramoDAO, new HibernateCompraDAO)
		destino = new Destino("Rosario")
		this.inicializarBaseDePrueba()
	}
	
	////////////////////////////////////////////////////////
	/**Agregar test signUp */
	////////////////////////////////////////////////////////
	
	@Test
	def testUnUsuarioQueNoTeniaNingunaPublicacionAgregeUnaPublicacionExitosamente(){
		
		var unaPublicacionResultado	 = agregarPublicacion("HunterJose","Hola pepita", Visibilidad.Publico, destino)

		assertNotNull(unaPublicacionResultado.id);
	}
	
	@Test(expected=AssertionError)
	def testgetName(){
		
		agregarPublicacion("HunterJose","Hola pepita", Visibilidad.Publico, destino)
		agregarPublicacion("HunterJose","Hola pepita", Visibilidad.Publico, destino)
		fail()
	}
	
	@Test(expected=AssertionError)
	def testxxx(){
		
	
		var aPublication 			 = new Publication("HunterJose","Hola pepita", Visibilidad.Publico, destino)
		perfilService.agregarPublicación("ddddd", aPublication) 
		fail()
	}
	@Test(expected=AssertionError)
	def testyyy(){
		
	
		var aPublication 			 = new Publication("HunterJose","Hola pepita", Visibilidad.Publico, new Destino("noExiste"))
		perfilService.agregarPublicación(usuario.userName, aPublication) 
		fail()
	}
	
	def Publication agregarPublicacion(String aUserName, String aCampo , Visibilidad aVisibilidad, Destino unDestino){
		perfilService.agregarPublicación(usuario.userName, new Publication(aUserName,aCampo, aVisibilidad,unDestino))
	}
	
	def void inicializarBaseDePrueba(){
		var aerolinea=new Aereolinea("Aterrizar")
		
		val asiento	= new Asiento(new Tramo(100.00, new Vuelo(aerolinea), 
			new Destino("asdas"), destino, LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)
		),new Turista)
		 
		val asiento2	= new Asiento(new Tramo(100.00, new Vuelo(aerolinea), 
			 new Destino("kk"), new Destino("caku"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00)
		),new Turista)
		
		
		Runner.runInSession[
			usuario.monedero = 5000.00
			hibernateUserDAO.update(usuario)
			asientoDAO.save(asiento)
			asientoDAO.save(asiento2)
			null
		]
		#[asiento,asiento2].forEach
		[
			reservaCompraDeAsientos.comprar(reservaCompraDeAsientos.reservar(it.id, usuario.userName).id, usuario.userName)
		]	
	}

	@Test
	def limpiador(){
		neo4jDao.clearAll
		publicationDao.deleteAll
		new TruncateTables => [ vaciarTablas ]
		assertTrue(true)
	}
	
	@After
	def void tearDown(){
		neo4jDao.clearAll
		publicationDao.deleteAll
		new TruncateTables => [ vaciarTablas ]
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}