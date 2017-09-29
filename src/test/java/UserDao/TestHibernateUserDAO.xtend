package UserDao

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import userDAO.UserDAO
import service.User
import java.util.Date
import org.junit.After
import userDAO.HibernateUserDAO
import runner.Runner
import asientoServicio.Compra
import aereolinea.Asiento
import java.util.ArrayList

class TestHibernateUserDAO {
		
	UserDAO userDAO
	User    userTest
	
	@Before
	def void setUp(){
		userDAO  = new HibernateUserDAO
		userTest = new User("Pepita","LaGolondrina","euforica","pepitagolondrina@gmail.com", "password", new Date())
		
	}
	
	@Test
	def void testAlGuardarYLuegoRecuperarSeObtieneObjetosSimilares() {
		userTest.agregarCompra(new Compra(new ArrayList<Asiento>,userTest))
	
		Runner.runInSession[ {
	
			userDAO.save(userTest)
			
			var otherUser = userDAO.load(userTest)
		
			assertEquals(userTest.name, otherUser.name)
			assertEquals(userTest.lastName, otherUser.lastName)
			assertEquals(userTest.userName, otherUser.userName)
			assertEquals(userTest.mail, otherUser.mail)
			assertEquals(userTest.birthDate, otherUser.birthDate)
			assertEquals(userTest.validate, otherUser.validate)

			assertTrue(userTest == otherUser);
			
			null
		}]
	
		
	}
	
//	@Test
//	def void test() {
//		Runner.runInSession[ {
//			userDAO.save(userTest)
//			null
//		}]
//		
//		Runner.runInSession[ {
//			var otherUser = userDAO.load(userTest)
//		
//			assertEquals(userTest.name, otherUser.name)
//			assertEquals(userTest.lastName, otherUser.lastName)
//			assertEquals(userTest.userName, otherUser.userName)
//			assertEquals(userTest.mail, otherUser.mail)
//			assertEquals(userTest.birthDate, otherUser.birthDate)
//
//			assertEquals(userTest.validate, otherUser.validate)
//
//			assertTrue(userTest != otherUser);
//			null
//		}]
//			
//		
//	}
//	
	
	@After
	def void tearDown(){
		userDAO.clearAll
	}
}