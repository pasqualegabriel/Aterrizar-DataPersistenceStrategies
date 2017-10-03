package service

import org.junit.Before
import org.junit.Test
import userDAO.JDBCUserDAO
import org.junit.After
import Excepciones.ExceptionUsuarioExistente
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords

class TestUserServiceJDBC extends UserServiceTests {
	
	@Before
	def void setUp(){
		before
	}
	
	override setUserService(){
		userDAO       = new JDBCUserDAO
		serviceTest   = new Service(userDAO, generatorMail, unGeneradorDeCodigo, unMailService)
	}
	
	@Test
	def test000JDBC(){
		
		test000UnServiceSabeQueExisteUnUsuarioConNombreyMail
	}

	@Test
	def test001JDBC(){

		test001UnServiceSabeQueNoExisteUnUsuarioConNombreyMail
	}
	
	@Test
	def test002JDBC(){

		test002SeRegistraUnUsuarioExitosamente
	}
	
	@Test(expected=ExceptionUsuarioExistente)
	def test003JDBC(){
	
		test003NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseUsuario
	}
	
	@Test(expected=ExceptionUsuarioExistente)
	def test004JDBC(){
		
		test004NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseMail
	}

	@Test
	def test005JDBC(){

		test005UnUsuarioValidaSuCodigoExitosamente
	}

	@Test(expected=InvalidValidationCode)
	def test006JDBC(){

		test006UnUsuarioAlValidaSuCodigoNoExisteDichoCodigo
	}
	
	@Test
	def test007JDBC(){

		test007UnUsuarioSeLogueaExitosamente
	}

	@Test(expected=IncorrectUsernameOrPassword)
	def test008JDBC(){

		test008UnUsuarioNoSeLogueaExitosamentePorqueNoSeValido
	}

	@Test(expected=IncorrectUsernameOrPassword)
	def test009JDBC(){

		test009UnUsuarioNoSeLogueaExitosamentePorqueNoExiste
	}

	@Test
	def test010JDBC(){

		test010UnUsuarioCambiaSuPasswordExitosamente
	}

	@Test(expected=IdenticPasswords)
	def test011JDBC(){
	
		test011UnUsuarioCambiaSuPasswordALaMismaPasswordQueTeniaAntesYElSistemaLeAvisaQueNoPuede
	}

	@Test(expected=IncorrectUsernameOrPassword)
	def test012JDBC(){
	
		test012UnUsuarioIntenaCambiarSuPasswordPeroSuNickOContraseñaNoSonCorrectos
	}
	
	@After
	def void tearDown(){
		userDAO.clearAll
		
	}
}