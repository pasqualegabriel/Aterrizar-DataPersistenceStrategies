package UserDao

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import service.User
import java.util.Date
import org.junit.After
import runner.Runner
import dao.UserDAO
import daoImplementacion.HibernateUserDAO
import java.util.List

class TestHibernateUserDAO {

	HibernateUserDAO userDAOSuj
	User userDoc

//	Asiento 	    asientoDoc
//	Tramo		    tramoDoc
//	Reserva			reservaDoc
//	Vuelo           vueloDoc
//	Aereolinea		aereolineaDoc
//	Compra			compraDoc
	@Before
	def void setUp() {
		userDAOSuj = new HibernateUserDAO
		userDoc = new User("Pepita", "LaGolondrina", "euforica", "pepitagolondrina@gmail.com", "password", new Date())
//		aereolineaDoc 	= new Aereolinea("Aterrizar")
//		vueloDoc		= new Vuelo(aereolineaDoc)
//		tramoDoc		= new Tramo(10.00, vueloDoc, new Destino("Mar Del Plata"), new Destino("Rosario"), LocalDateTime.of(2017, 1, 10, 10,10, 30,00), LocalDateTime.of(2017, 1, 10, 10, 19, 30,00))	
//		asientoDoc		= new Asiento(tramoDoc,new Turista)
//		reservaDoc		= new Reserva
//		var asientos	= newArrayList
//		asientos.add(asientoDoc)
//		compraDoc		= new Compra(asientos,userDoc)
//		userDoc.agregarCompra(compraDoc)
//		userDoc.reserva = reservaDoc
	}

	@Test
	def void testAlGuardarYLuegoRecuperarSeObtieneObjetosSimilares() {

		Runner.runInSession [
			{

				userDAOSuj.save(userDoc)

				var otherUser = userDAOSuj.loadbyname(userDoc.userName)

				assertEquals(userDoc.reserva, otherUser.reserva)
				assertEquals(userDoc.compras, otherUser.compras)
				assertEquals(userDoc.name, otherUser.name)
				assertEquals(userDoc.lastName, otherUser.lastName)
				assertEquals(userDoc.userName, otherUser.userName)
				assertEquals(userDoc.mail, otherUser.mail)
				assertEquals(userDoc.birthDate, otherUser.birthDate)
				assertEquals(userDoc.validate, otherUser.validate)

				assertTrue(userDoc == otherUser)

				null
			}
		]

	}

	@Test
	def void testAlHacerUnSaveYCerrarLaSeccionCuandoAbrimosUnaNuevaYHacemosLoadLasIntanciasSonDiferentes() {

		Runner.runInSession [
			{

				userDAOSuj.save(userDoc)
				null
			}
		]

		Runner.runInSession [
			{

				var otherUser = userDAOSuj.load(userDoc)

				assertEquals(userDoc.name, otherUser.name)
				assertEquals(userDoc.lastName, otherUser.lastName)
				assertEquals(userDoc.userName, otherUser.userName)
				assertEquals(userDoc.mail, otherUser.mail)
				// assertEquals(userTest.birthDate, otherUser.birthDate)
				assertEquals(userDoc.validate, otherUser.validate)

				assertTrue(userDoc != otherUser)

				null
			}
		]
	}

	@Test
	def void testAlGuardarYUpdatearAUnUsuarioSeVerificaQueSePersistieronLosCambios() {

		Runner.runInSession [
			{

				userDAOSuj.save(userDoc)

				assertEquals(userDoc.lastName, "LaGolondrina")

				userDoc.lastName = "newUserName"

				userDAOSuj.update(userDoc)

				var otherUser = userDAOSuj.load(userDoc)

				assertEquals(otherUser.lastName, "newUserName")
				
				null
				}
			]

	}

	@After
	def void tearDown() {
		Runner.runInSession [{
			
		
		val session = Runner.getCurrentSession();
		var List<String> nombreDeTablas = session.createNativeQuery("show tables").getResultList();
		session.createNativeQuery("SET FOREIGN_KEY_CHECKS=0;").executeUpdate();
		nombreDeTablas.forEach [
			session.createNativeQuery("truncate table " + it).executeUpdate();
		];
		session.createNativeQuery("SET FOREIGN_KEY_CHECKS=1;").executeUpdate();
		null
			}
		]
	}
}
