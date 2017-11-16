package perfiles

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.junit.After
import service.User
import aereolinea.Destino
import daoImplementacion.ProfileDAO
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
import Excepciones.ExceptionNoVisitoDestino

class TestPerfilService {
	
	User 			usuario
	PerfilService 	perfilService
	ProfileDAO      profileDAO
	HibernateUserDAO hibernateUserDAO
	UserService serviceTest
	@Mock EmailService  unMailService
	@Mock MailGenerator generatorMail
	Destino destino
	AsientoService reservaCompraDeAsientos
	
	HibernateAsientoDAO asientoDAO
	
	UserNeo4jDAO			neo4jDao
	
	@Before
	def void setUp(){
		MockitoAnnotations.initMocks(this)
		hibernateUserDAO 	= new HibernateUserDAO
		neo4jDao            = new UserNeo4jDAO
		profileDAO			= new ProfileDAO
		asientoDAO          = new HibernateAsientoDAO
        hibernateUserDAO    = new HibernateUserDAO
		serviceTest   		= new ServiceHibernate(hibernateUserDAO, generatorMail, new RandomNumberGenerator, unMailService)
		usuario      	 	= serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com", "password",new Date())
		perfilService 		= new Xxxx(profileDAO,hibernateUserDAO)
		reservaCompraDeAsientos = new ReservaCompraDeAsientos(hibernateUserDAO, asientoDAO, new HibernateReservaDAO, new HibernateTramoDAO, new HibernateCompraDAO)
		destino = new Destino("Rosario")
		
		
	}
	
	////
	/**Agregar test signUp */
	////////////////
	
	@Test
	def testUnUsuarioQueNoTeniaNingunaPublicacionAgregeUnaPublicacionExitosamente(){
		
		this.xxxx()
		var aPublication 			 = new Publicacion("Hola pepita", Visibilidad.Publico, destino)
		var unaPublicacionResultado	 = perfilService.agregarPublicación(usuario.userName, aPublication) 
		
		assertEquals(aPublication, unaPublicacionResultado)
	}
	@Test(expected=ExceptionNoVisitoDestino)
	def testxxx(){
		
		this.xxxx()
		var aPublication 			 = new Publicacion("Hola pepita", Visibilidad.Publico, destino)
		perfilService.agregarPublicación("ddddd", aPublication) 
		fail()
	}
	@Test(expected=ExceptionNoVisitoDestino)
	def testyyy(){
		
		this.xxxx()
		var aPublication 			 = new Publicacion("Hola pepita", Visibilidad.Publico, new Destino("noExiste"))
		perfilService.agregarPublicación(usuario.userName, aPublication) 
		fail()
	}
	
	def void xxxx(){
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

//	@Test
//	def limpiador(){
//		neo4jDao.clearAll
//		profileDAO.deleteAll
//		new TruncateTables => [ vaciarTablas ]
//		assertTrue(true)
//	}
	
	@After
	def void tearDown(){
		neo4jDao.clearAll
		profileDAO.deleteAll
		new TruncateTables => [ vaciarTablas ]
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}