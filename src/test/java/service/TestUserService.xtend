package service

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import java.util.Date
import org.junit.After
import mailSender.EmailService
import mailSender.Postman
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import Excepciones.ExceptionUsuarioExistente
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords
import dao.UserDAO
import daoImplementacion.HibernateUserDAO
import runner.Runner

class TestUserService {
	
	UserService			serviceTest
	UserDAO 			userDAO
	CodeGenerator       unGeneradorDeCodigo
	@Mock EmailService  unMailService
	@Mock MailGenerator generatorMail
	
	@Before
	def void setUp(){
		MockitoAnnotations.initMocks(this)
        unGeneradorDeCodigo = new RandomNumberGenerator
	    unMailService = new Postman
	    generatorMail = new SimpleMailer
        userDAO       = new HibernateUserDAO
		serviceTest   = new ServiceHibernate(userDAO, generatorMail, unGeneradorDeCodigo, unMailService)
	}

	@Test
	def testSeRegistraUnUsuarioExitosamente(){

		var user = serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com", "password",new Date())
		
	    assertEquals(user.name,     "Pepita")
		assertEquals(user.lastName, "LaGolondrina")
		assertEquals(user.userName, "PepitaUser")
		assertEquals(user.mail,     "pepitagolondrina@gmail.com")
		assertEquals(user.validate, false)
	}
	
	@Test(expected=ExceptionUsuarioExistente)
	def testNoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseUsuario(){

		serviceTest.singUp("Goku","Kakaroto","SonGoku","goku@gmail.com", "goku",new Date())
		
		serviceTest.singUp("Goku","Kakaroto","SonGoku","goku@gmail.com", "goku",new Date())
		             
		fail()
	}
	
	@Test(expected=ExceptionUsuarioExistente)
	def testNoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseMail(){

		serviceTest.singUp("Pepita2","LaGolondrina2","pepita2",    "pepita2@gmail.com", "password2",new Date())
		
		serviceTest.singUp("Pepita2","LaGolondrina2","PepitaUser2","pepita2@gmail.com", "password2",new Date())
		            
		fail()
	}
	
	@Test
	def void testUnUsuarioValidaSuCodigoExitosamente(){
		
		var newUser = serviceTest.singUp("Vegeta","Saiyan","vegetaUser","vegeta@gmail.com","VegetaPassword",new Date())
		
		assertFalse(newUser.validate)
		
        var isValid = serviceTest.validate(newUser.validateCode)
        
        assertTrue(isValid)
        
        Runner.runInSession [{
        
        	var userExample      = new User
        	userExample.userName = "vegetaUser"
			var user             = userDAO.load(userExample)
		
	    	assertEquals(user.name,     "Vegeta")
			assertEquals(user.lastName, "Saiyan")
			assertEquals(user.userName, "vegetaUser")
			assertEquals(user.mail,     "vegeta@gmail.com")
			assertTrue(user.validate)
			null
	    }]
	}
	
	
	@Test(expected=InvalidValidationCode)
	def testUnUsuarioAlValidaSuCodigoNoExisteDichoCodigo(){

		serviceTest.singUp("Gohan","SonGohan","GohanUser","gohan@gmail.com", "GohanPassword",new Date())

		serviceTest.validate("validateCodeInexistente")
		
		fail()
	}

	@Test 
	def testUnUsuarioSeLogueaExitosamente(){
		
		val user = serviceTest.singUp("Trunks","trunks","TrunksUser","trunks@gmail.com", "password",new Date())
		serviceTest.validate(user.validateCode)
		
		val userSignIn = serviceTest.signIn("TrunksUser","password")
		
	    assertEquals(userSignIn.name,     "Trunks")
		assertEquals(userSignIn.lastName, "trunks")
		assertEquals(userSignIn.userName, "TrunksUser")
		assertEquals(userSignIn.mail,     "trunks@gmail.com")
	}
	
	@Test(expected=typeof(RuntimeException))
	def test008UnUsuarioNoSeLogueaExitosamentePorqueNoSeValido(){
		
		serviceTest.singUp("Goten","SonGoten","GotenUser","Goten@gmail.com", "password",new Date())
		
		serviceTest.signIn("GotenUser","password")

		fail()
	}
	
	@Test(expected=typeof(RuntimeException))
	def testUnUsuarioNoSeLogueaExitosamentePorqueNoExiste(){
		
		serviceTest.signIn("usuarioNoExistente","passwordNoExistente")
		
		fail()
	}
	
	@Test 
	def void testUnUsuarioCambiaSuPasswordExitosamente(){
	
		serviceTest.singUp("Dionisia","Golondrina","dionisiaUser","dionisia@gmail.com", "dionisiaPassword",new Date())

		serviceTest.changePassword("dionisiaUser","dionisiaPassword","newPassword")
        
        Runner.runInSession [
			var userExample      = new User
        	userExample.userName = "dionisiaUser"
		
			var user = userDAO.load(userExample)
		
	    	assertEquals(user.userPassword, "newPassword")
	    	
	    	null
	    ]
	    
	}

	@Test(expected=IdenticPasswords)
	def testUnUsuarioCambiaSuPasswordALaMismaPasswordQueTeniaAntesYElSistemaLeAvisaQueNoPuede(){
		
		serviceTest.singUp("Piccolo","Namek","piccoloUser","piccolo@gmail.com", "piccoloPassword",new Date())
		
		serviceTest.changePassword("piccoloUser","piccoloPassword","piccoloPassword")
		// Error = "Las contraseñas no tienen que ser las mismas"
	}
	
	@Test(expected=IncorrectUsernameOrPassword)
	def testUnUsuarioIntenaCambiarSuPasswordPeroSuNickOContraseñaNoSonCorrectos(){
		
		serviceTest.singUp("krilin","KameHouse","krilinUser","krilin@gmail.com", "krilinPassword",new Date())
		
		serviceTest.changePassword("userFaild","krilinPassword","newPassword")
		// Error = "El usuario o la contrasenia introducidos no son correctos"
	}
	
	@After
	def void tearDown(){

		new TruncateTables => [ vaciarTablas ]

	}
}

class TruncateTables {
	
	def vaciarTablas(){

		Runner.runInSession [
			
			val session = Runner.getCurrentSession
			var nombreDeTablas = session.createNativeQuery("show tables").getResultList
			session.createNativeQuery("SET FOREIGN_KEY_CHECKS=0;").executeUpdate
			nombreDeTablas.forEach [
				session.createNativeQuery("truncate table " + it).executeUpdate
			]
			session.createNativeQuery("SET FOREIGN_KEY_CHECKS=1;").executeUpdate
            session.createNativeQuery("insert into hibernate_sequence(next_val) values(0);").executeUpdate
			null	
		]

	}
	
}




