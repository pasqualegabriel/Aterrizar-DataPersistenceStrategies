package UserDao

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import userDAO.JDBCUserDAO
import userDAO.UserDAO
import service.User
import java.util.Date
import org.junit.After

class TestUserDao {
	
	UserDAO userDAO
	User    userTest
	
	@Before
	def void setUp(){
		userDAO  = new JDBCUserDAO
		userTest = new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date())
	}
	
	@Test
	def test00AlGuardarYLuegoRecuperarSeObtieneObjetosSimilares() {
		
		userDAO.save(userTest)
		
		var ejemplo  = new User()
		ejemplo.name = "Pepita"
		ejemplo.mail = "pepitagolondrina@gmail.com"
		
		val otherUser = userDAO.load(ejemplo)
		assertEquals(userTest.name, otherUser.name)
		assertEquals(userTest.lastName, otherUser.lastName)
		assertEquals(userTest.userName, otherUser.userName)
		assertEquals(userTest.mail, otherUser.mail)
		assertEquals(userTest.birthDate, otherUser.birthDate)
		assertEquals(userTest.validate, otherUser.validate)

		assertTrue(userTest != otherUser);
	}

	@Test
	def test01SeUpdateaAPepita() {
		
		userDAO.save(userTest)
		
		userTest.name     = "Dionisia"
		userTest.lastName = "golovieja"
		userTest.validate = true
		
		userDAO.update(userTest)
			
		var ejemplo      = new User()
		ejemplo.userName = "euforica"
		
		var otherUser    = userDAO.load(ejemplo)
		
		assertEquals(otherUser.name,     "Dionisia")
		assertEquals(otherUser.lastName, "golovieja")
		assertTrue(otherUser.validate)
	}
	
	@Test
	def test02AlGuardarYLuegoRecuperarBuscandoPorMailSeObtieneObjetosSimilares() {
		
		userDAO.save(userTest)
		
		var ejemplo  = new User()
		ejemplo.mail = "pepitagolondrina@gmail.com"
		
		val otherUser = userDAO.load(ejemplo)
		assertEquals(userTest.name, otherUser.name)
		assertEquals(userTest.lastName, otherUser.lastName)
		assertEquals(userTest.userName, otherUser.userName)
		assertEquals(userTest.mail, otherUser.mail)
		assertEquals(userTest.birthDate, otherUser.birthDate)
		assertEquals(userTest.validate, otherUser.validate)

		assertTrue(userTest != otherUser)
	}
	
	@Test
	def test03AlGuardarYLuegoRecuperarBuscandoPorUserNameSeObtieneObjetosSimilares() {
		
		userDAO.save(userTest)
		
		var ejemplo  = new User()
		ejemplo.userName = "euforica"
		
		val otherUser = userDAO.load(ejemplo)
		assertEquals(userTest.name, otherUser.name)
		assertEquals(userTest.lastName, otherUser.lastName)
		assertEquals(userTest.userName, otherUser.userName)
		assertEquals(userTest.mail, otherUser.mail)
		assertEquals(userTest.birthDate, otherUser.birthDate)
		assertEquals(userTest.validate, otherUser.validate)

		assertTrue(userTest != otherUser)
	}
	
	@Test
	def test04AlBuscarUnUsuarioNoExistenteNoDevuelveNada() {
		
		var ejemplo  = new User()
		ejemplo.mail = "juan@gmail.com"

		assertNull(userDAO.load(ejemplo))
	}
	
	@Test
	def test05SeIntentaUpdatearUnUserNoExistente() {
		userDAO.update(userTest)
		
		
		assertTrue(true)
	}
	

	
	@After
	def void tearDown(){
		userDAO.clearAll
		// Preguntar si hay alguna manera de saber la cantidad de usuarios
	}
	
}