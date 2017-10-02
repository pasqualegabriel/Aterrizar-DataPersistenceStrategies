package service

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import userDAO.JDBCUserDAO
import java.util.Date
import org.junit.After
import mailSender.EmailService
import mailSender.Postman
import static org.mockito.Mockito.*
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import mailSender.Mail
import Excepciones.ExceptionUsuarioExistente
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords
import dao.UserDAO
import daoImplementacion.HibernateUserDAO

class TestUserService {
	
	protected Service 			  serviceTest
	protected UserDAO 			  userDAO
	protected User   			  userTest
	@Mock protected CodeGenerator unGeneradorDeCodigo
	@Mock protected EmailService  unMailService
	@Mock protected MailGenerator generatorMail
	@Mock protected Mail		  unMail
	
	@Before
	def void setUp(){
		MockitoAnnotations.initMocks(this)
		when(unGeneradorDeCodigo.generarCodigo).thenReturn("1234567890")
		when(generatorMail.generarMail("1234567890pepitaUser","pepitagolondrina@gmail.com")).thenReturn(unMail)
		userDAO       = new HibernateUserDAO
	    unMailService = new Postman
	    generatorMail = new SimpleMailer
		serviceTest   = new ServiceHibernate(userDAO, generatorMail, unGeneradorDeCodigo, unMailService)
		userTest      = new User("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com","password",new Date())
	}
	
	def setHibernate(){
		userDAO       = new JDBCUserDAO
		serviceTest   = new Service(userDAO, generatorMail, unGeneradorDeCodigo, unMailService)
	}

	@Test
	def test000UnServiceSabeQueExisteUnUsuarioConNombreyMail(){	

		serviceTest.saveUser(userTest)
		assertTrue(serviceTest.existeUsuarioCon("PepitaUser","pepitagolondrina@gmail.com"))
	}	
	
	@Test
	def test001UnServiceSabeQueNoExisteUnUsuarioConNombreyMail(){	

		assertFalse(serviceTest.existeUsuarioCon("PepitaUser","pepitagolondrina@gmail.com"))
	}

	@Test
	def test002SeRegistraUnUsuarioExitosamente(){

		var user = serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com", "password",new Date())
		
	    assertEquals(user.name, "Pepita")
		assertEquals(user.lastName, "LaGolondrina")
		assertEquals(user.userName, "PepitaUser")
		assertEquals(user.mail, "pepitagolondrina@gmail.com")
		assertEquals(user.validate, false)
	}
	
	@Test(expected=ExceptionUsuarioExistente)
	def test003NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseUsuario(){

		serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com",  "password",new Date())
		
		serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita2@gmail.com", "password",new Date())
		             
		fail()
	}
	
	@Test(expected=ExceptionUsuarioExistente)
	def test004NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseMail(){

		serviceTest.singUp("Pepita","LaGolondrina","pepita",    "pepita@gmail.com", "password",new Date())
		
		serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com", "password",new Date())
		            
		fail()
	}
	
	@Test
	def test005UnUsuarioValidaSuCodigoExitosamente(){
		
		var newUser = serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com","password",new Date())
		
		assertFalse(newUser.validate)
		
        var isValid = serviceTest.validate(newUser.validateCode)
        
        var userExample      = new User
        userExample.userName = "PepitaUser"
		var user             = serviceTest.loadUser(userExample)
		
		assertTrue(isValid)
	    assertEquals(user.name,     "Pepita")
		assertEquals(user.lastName, "LaGolondrina")
		assertEquals(user.userName, "PepitaUser")
		assertEquals(user.mail,     "pepita@gmail.com")
		assertTrue(user.validate)
	}
	
	
	@Test(expected=InvalidValidationCode)
	def test006UnUsuarioAlValidaSuCodigoNoExisteDichoCodigo(){

		val user = serviceTest.singUp("Pepita","LaGolondrina","pepita","pepita@gmail.com", "password",new Date())

		serviceTest.validate(user.validateCode)
		
		fail()
	}

	@Test 
	def test007UnUsuarioSeLogueaExitosamente(){
		
		val user = serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		serviceTest.validate(user.validateCode)
		
		val userSignIn = serviceTest.signIn("pepitaUser","password")
		
	    assertEquals(userSignIn.name,     "Pepita")
		assertEquals(userSignIn.lastName, "LaGolondrina")
		assertEquals(userSignIn.userName, "pepitaUser")
		assertEquals(userSignIn.mail,     "pepita@gmail.com")
	}
	
	@Test(expected=typeof(RuntimeException))
	def test008UnUsuarioNoSeLogueaExitosamentePorqueNoSeValido(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.signIn("pepitaUser","password")

		fail()
	}
	
	@Test(expected=typeof(RuntimeException))
	def test009UnUsuarioNoSeLogueaExitosamentePorqueNoExiste(){
		
		serviceTest.signIn("usuarioNoExistente","passwordNoExistente")
		
		fail()
	}
	
	@Test 
	def test010UnUsuarioCambiaSuPasswordExitosamente(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("pepitaUser","password","newPassword")
		
		var userExample      = new User
        userExample.userName = "pepitaUser"
		var user = serviceTest.loadUser(userExample)
		
	    assertEquals(user.userPassword, "newPassword")
	}

	@Test(expected=IdenticPasswords)
	def test011UnUsuarioCambiaSuPasswordALaMismaPasswordQueTeniaAntesYElSistemaLeAvisaQueNoPuede(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("pepitaUser","password","password")
		// Error = "Las contraseñas no tienen que ser las mismas"
	}
	
	@Test(expected=IncorrectUsernameOrPassword)
	def test012UnUsuarioIntenaCambiarSuPasswordPeroSuNickOContraseñaNoSonCorrectos(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("userFaild","password","newPassword")
		// Error = "El usuario o la contrasenia introducidos no son correctos"
	}
	
	@After
	def void tearDown(){
		userDAO.clearAll
		
	}
}




