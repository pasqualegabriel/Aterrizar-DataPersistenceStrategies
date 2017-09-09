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
	User userTest
	@Before
	def void setUp(){
		userDAO  =   new JDBCUserDAO
		userTest = new User("Pepita","LaGolondrina" , "euforica", "pepitagolondrina@gmail.com", new Date())
		userTest.validateCode= "golond"
		userTest.userPassword= "123123"

	}
	
	@Test
	def test00AlGuardarYLuegoRecuperarSeObtieneObjetosSimilares() {
		userDAO.save(userTest)
		
		var ejemplo = new User()
		ejemplo.name= "Pepita"
		ejemplo.mail= "pepitagolondrina@gmail.com"
		
	
		val otherUser = userDAO.load(ejemplo)
		assertEquals(userTest.name, otherUser.name)
		assertEquals(userTest.lastName, otherUser.lastName)
		assertEquals(userTest.userName, otherUser.userName)
		assertEquals(userTest.mail, otherUser.mail)
		assertEquals(userTest.birthDate, otherUser.birthDate)
		assertEquals(userTest.validateCode, otherUser.validateCode)
		assertEquals(userTest.validate, otherUser.validate)


		assertTrue(userTest != otherUser);
		assertTrue(true)
	}

	@Test
	def test00SeUpdateaAPepita() {
		userDAO.save(userTest)
		
		userTest.name= "Dionisia"
		userTest.lastName= "golovieja"
		
		userDAO.update(userTest)
		
		
		var ejemplo = new User()
		ejemplo.userName= "euforica"
		
		var otherUser = userDAO.load(ejemplo)
		
		assertEquals(otherUser.name, "Dionisia")
		assertEquals(otherUser.lastName, "golovieja")
	}
	
	@After
	def void tearDown(){
		userDAO.clearAll
		
	}
	
}