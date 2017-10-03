package service

import static org.junit.Assert.*
import java.util.Date
import mailSender.EmailService
import mailSender.Postman
import static org.mockito.Mockito.*
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import mailSender.Mail
import dao.UserDAO
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class UserServiceTests {
	
	Service 			serviceTest
	UserDAO 			userDAO
	User   			    userTest
	@Mock CodeGenerator unGeneradorDeCodigo
	@Mock EmailService  unMailService
	@Mock MailGenerator generatorMail
	@Mock Mail		    unMail
	
	def void before(){
		MockitoAnnotations.initMocks(this)
		when(unGeneradorDeCodigo.generarCodigo).thenReturn("1234567890")
		when(generatorMail.generarMail("1234567890pepitaUser","pepitagolondrina@gmail.com")).thenReturn(unMail)
	    unMailService = new Postman
	    generatorMail = new SimpleMailer
		userTest      = new User("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com","password",new Date())
		setUserService
	}
	
	def abstract void setUserService()
	
	def test000UnServiceSabeQueExisteUnUsuarioConNombreyMail(){	

		serviceTest.saveUser(userTest)
		assertTrue(serviceTest.existeUsuarioCon("PepitaUser","pepitagolondrina@gmail.com"))
	}	
	
	def test001UnServiceSabeQueNoExisteUnUsuarioConNombreyMail(){	

		assertFalse(serviceTest.existeUsuarioCon("PepitaUser","pepitagolondrina@gmail.com"))
	}

	def test002SeRegistraUnUsuarioExitosamente(){

		var user = serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com", "password",new Date())
		
	    assertEquals(user.name, "Pepita")
		assertEquals(user.lastName, "LaGolondrina")
		assertEquals(user.userName, "PepitaUser")
		assertEquals(user.mail, "pepitagolondrina@gmail.com")
		assertEquals(user.validate, false)
	}
	
	def test003NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseUsuario(){

		serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com",  "password",new Date())
		
		serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita2@gmail.com", "password",new Date())
		             
		fail()
	}
	
	def test004NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseMail(){

		serviceTest.singUp("Pepita","LaGolondrina","pepita",    "pepita@gmail.com", "password",new Date())
		
		serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com", "password",new Date())
		            
		fail()
	}
	
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

	def test006UnUsuarioAlValidaSuCodigoNoExisteDichoCodigo(){

		serviceTest.singUp("Pepita","LaGolondrina","pepita","pepita@gmail.com", "password",new Date())

		serviceTest.validate("validateCodeInexistente")
		
		fail()
	}

	def test007UnUsuarioSeLogueaExitosamente(){
		
		val user = serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		serviceTest.validate(user.validateCode)
		
		val userSignIn = serviceTest.signIn("pepitaUser","password")
		
	    assertEquals(userSignIn.name,     "Pepita")
		assertEquals(userSignIn.lastName, "LaGolondrina")
		assertEquals(userSignIn.userName, "pepitaUser")
		assertEquals(userSignIn.mail,     "pepita@gmail.com")
	}

	def test008UnUsuarioNoSeLogueaExitosamentePorqueNoSeValido(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.signIn("pepitaUser","password")

		fail()
	}

	def test009UnUsuarioNoSeLogueaExitosamentePorqueNoExiste(){
		
		serviceTest.signIn("usuarioNoExistente","passwordNoExistente")
		
		fail()
	}

	def test010UnUsuarioCambiaSuPasswordExitosamente(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("pepitaUser","password","newPassword")
		
		var userExample      = new User
        userExample.userName = "pepitaUser"
		var user = serviceTest.loadUser(userExample)
		
	    assertEquals(user.userPassword, "newPassword")
	}

	def test011UnUsuarioCambiaSuPasswordALaMismaPasswordQueTeniaAntesYElSistemaLeAvisaQueNoPuede(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("pepitaUser","password","password")
		// Error = "Las contraseñas no tienen que ser las mismas"
	}

	def test012UnUsuarioIntenaCambiarSuPasswordPeroSuNickOContraseñaNoSonCorrectos(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("userFaild","password","newPassword")
		// Error = "El usuario o la contrasenia introducidos no son correctos"
	}
	
	def void after(){
		userDAO.clearAll
		
	}
	
}