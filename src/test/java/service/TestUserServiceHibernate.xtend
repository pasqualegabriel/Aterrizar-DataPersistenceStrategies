package service

import org.junit.Before
import org.junit.Test
import org.junit.After
import Excepciones.ExceptionUsuarioExistente
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords
import daoImplementacion.HibernateUserDAO

class TestUserServiceHibernate extends UserServiceTests {

	@Before
	def void setUp(){
		before
	}
	
	override setUserService(){
		userDAO       = new HibernateUserDAO
		serviceTest   = new ServiceHibernate(userDAO, generatorMail, unGeneradorDeCodigo, unMailService)
	}

	@Test
	def test000Hibernate(){

		test000UnServiceSabeQueExisteUnUsuarioConNombreyMail
	}

	@Test
	def test001Hibernate(){

		test001UnServiceSabeQueNoExisteUnUsuarioConNombreyMail
	}

	@Test
	def test002Hibernate(){

		test002SeRegistraUnUsuarioExitosamente
	}

	@Test(expected=ExceptionUsuarioExistente)
	def test003Hibernate(){
	
		test003NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseUsuario
	}

	@Test(expected=ExceptionUsuarioExistente)
	def test004Hibernate(){
		
		test004NoSeRegistraUnUsuarioConNombrePepitaExitosamentePorqueYaExisteEseMail
	}

	@Test
	def test005Hibernate(){
		
		test005UnUsuarioValidaSuCodigoExitosamente
	}

	@Test(expected=InvalidValidationCode)
	def test006Hibernate(){
	
		test006UnUsuarioAlValidaSuCodigoNoExisteDichoCodigo
	}

	@Test
	def test007Hibernate(){
	
		test007UnUsuarioSeLogueaExitosamente
	}
	
	@Test(expected=IncorrectUsernameOrPassword)
	def test008Hibernate(){
		
		test008UnUsuarioNoSeLogueaExitosamentePorqueNoSeValido
	}

	@Test(expected=IncorrectUsernameOrPassword)
	def test009Hibernate(){
		
		test009UnUsuarioNoSeLogueaExitosamentePorqueNoExiste
	}

	@Test
	def test010Hibernate(){
	
		test010UnUsuarioCambiaSuPasswordExitosamente
	}

	@Test(expected=IdenticPasswords)
	def test011Hibernate(){

		test011UnUsuarioCambiaSuPasswordALaMismaPasswordQueTeniaAntesYElSistemaLeAvisaQueNoPuede
	}

	@Test(expected=IncorrectUsernameOrPassword)
	def test012Hibernate(){
	
		test012UnUsuarioIntenaCambiarSuPasswordPeroSuNickOContraseñaNoSonCorrectos
	}

	@After
	def void tearDown(){
		after
		
	}
	
}