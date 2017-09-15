package service

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import userDAO.JDBCUserDAO
import java.util.Date
import userDAO.UserDAO
import org.junit.After

class TestUserService {
	
	Service serviceTest
	UserDAO userDAO
	User    userTest
	
	@Before
	def void setUp(){
		userDAO     = new JDBCUserDAO
		serviceTest = new Service(userDAO)
		userTest    = new User("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com","password",new Date())
	}

	@Test
	def test000UnServiceSabeQueExisteUnUsuarioConNombreyMail(){	

		userDAO.save(userTest)
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
	
	@Test(expected=typeof(RuntimeException))
	def test003NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseUsuario(){

		serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com", "password",new Date())
		
		assertEquals(serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepitagolondrina@gmail.com", "password",new Date()),
		             "no se puede registrar el Usuario")
	}
	
	@Test(expected=RuntimeException)
	def test004NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseMail(){

		serviceTest.singUp("Pepita","LaGolondrina","pepita","pepita@gmail.com", "password",new Date())
		
		assertEquals(serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com", "password",new Date()),
		             "no se puede registrar el Usuario")
	}
	
	@Test
	def test005UnUsuarioValidaSuCodigoExitosamente(){
		
		var newUser = serviceTest.singUp("Pepita","LaGolondrina","PepitaUser","pepita@gmail.com","password",new Date())
		
		assertFalse(newUser.validate)
		
        var isValid = serviceTest.validate("1234567890PepitaUser")
        
        var userExample      = new User
        userExample.userName = "PepitaUser"
		var user             = userDAO.load(userExample)
		
		assertTrue(isValid)
	    assertEquals(user.name, "Pepita")
		assertEquals(user.lastName, "LaGolondrina")
		assertEquals(user.userName, "PepitaUser")
		assertEquals(user.mail, "pepita@gmail.com")
		assertTrue(user.validate)
	}
	
	
	@Test(expected=RuntimeException)
	def test006UnUsuarioAlValidaSuCodigoNoExisteDichoCodigo(){

		serviceTest.singUp("Pepita","LaGolondrina","pepita","pepita@gmail.com", "password",new Date())
		// el userName del codigo no coincide con ningun usuario en la base de datos y por eso levanta al exepcion
		val isValid = serviceTest.validate("1234567890PepitaUser")
		
		assertEquals(isValid, "El codigo no es correcto")
	}

	@Test 
	def test007UnUsuarioSeLogueaExitosamente(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		serviceTest.validate("1234567890pepitaUser")
		
		val user = serviceTest.signIn("pepitaUser","password")
		
	    assertEquals(user.name, "Pepita")
		assertEquals(user.lastName, "LaGolondrina")
		assertEquals(user.userName, "pepitaUser")
		assertEquals(user.mail, "pepita@gmail.com")
	}
	
	@Test(expected=typeof(RuntimeException))
	def test008UnUsuarioNoSeLogueaExitosamentePorqueNoSeValido(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		assertEquals(serviceTest.signIn("pepitaUser","password"), 
		"El usuario o la contrasenia introducidos no son correctos")
	}
	
	@Test(expected=typeof(RuntimeException))
	def test009UnUsuarioNoSeLogueaExitosamentePorqueNoExiste(){
		
		assertEquals(serviceTest.signIn("usuarioNoExistente","passwordNoExistente"), 
		"El usuario o la contrasenia introducidos no son correctos")
	}
	
	@Test 
	def test010UnUsuarioCambiaSuPasswordExitosamente(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("pepitaUser","password","newPassword")
		
		var userExample      = new User
        userExample.userName = "pepitaUser"
		var user = userDAO.load(userExample)
		
	    assertEquals(user.userPassword, "newPassword")
	}

	@Test(expected=typeof(RuntimeException))
	def test011UnUsuarioCambiaSuPasswordALaMismaPasswordQueTeniaAntesYElSistemaLeAvisaQueNoPuede(){
		
		serviceTest.singUp("Pepita","LaGolondrina","pepitaUser","pepita@gmail.com", "password",new Date())
		
		serviceTest.changePassword("pepitaUser","password","password")
		// Error = "Las contraseñas no tienen que ser las mismas"
	}
	
	@Test(expected=typeof(RuntimeException))
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




