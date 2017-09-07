package service

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import static org.mockito.Mockito.*
import org.mockito.MockitoAnnotations
import org.mockito.Mock
import userDAO.JDBCUserDAO
import Excepciones.InvalidValidationCode
import Excepciones.IncorrectUsernameOrPassword
import Excepciones.IdenticPasswords

class TestUserService {
	
	Service           serviceTest
	@Mock JDBCUserDAO JDBCUserDAOMock
	@Mock User        usuarioMock
	
	
	@Before
	def void setUp(){
		MockitoAnnotations.initMocks(this)
		serviceTest = new Service(JDBCUserDAOMock)
		
	}
	
	
	@Test
	def test000UnServiceSabeQueExisteUnUsuarioConNombreyMail(){

		when(JDBCUserDAOMock.loadForUsernameAndMail("PepitaUser","pepita@gmail.com")).thenReturn(usuarioMock)
		
		assertTrue(serviceTest.existeUsuarioCon("PepitaUser", "pepita@gmail.com"))
		
	}	
	
	@Test
	def test000UnServiceSabeQueNoExisteUnUsuarioConNombreyMail(){

		var excepcion = new RuntimeException 

		when(JDBCUserDAOMock.loadForUsernameAndMail("PepitaUser","pepita@gmail.com")).thenThrow(excepcion)
		
		assertFalse(serviceTest.existeUsuarioCon("PepitaUser", "pepita@gmail.com"))
	}	
	

	@Test
	def test000SeRegistraUnUsuarioConNombrePepitaExitosamente(){
		
		var excepcion = new RuntimeException 
		
		when(JDBCUserDAOMock.loadForUsernameAndMail("3","4")).thenThrow(excepcion)
		var pepita =serviceTest.singUp("1","2","3","4","5")
		
		/**Falta hacer Mock y verificar la parte de hacer el codigo y mandar mail */
		
	    verify(JDBCUserDAOMock, times(1)).save(pepita)
	}
	
	@Test (expected=typeof(RuntimeException))
	def test000NoSeRegistraUnUsuarioConNombrePepitaExitosamente(){
		
		when(JDBCUserDAOMock.loadForUsernameAndMail("3","4")).thenReturn(usuarioMock)
		var pepita =serviceTest.singUp("1","2","3","4","5")
		
	    verify(JDBCUserDAOMock, times(0)).save(pepita)
	}
	
	@Test
	def test000UnUsuarioValidaSuCodigoExitosamente(){
		
		when(JDBCUserDAOMock.loadForCode("a")).thenReturn(usuarioMock)
		
		
		assertTrue(serviceTest.validate("a"))
	}
	
	@Test 
	def test000UnUsuarioAlValidaSuCodigoNoExisteDichoCodigo(){
		var retorno= false
		var excepcion = new RuntimeException 
		
		when(JDBCUserDAOMock.loadForCode("a")).thenThrow(excepcion)
		try{ serviceTest.validate("a")}
		catch(InvalidValidationCode e) {retorno= true}
		assertTrue(retorno)
	}
	
	@Test 
	def test000UnUsuarioSeLogueaExitosamente(){
		when(JDBCUserDAOMock.load("pepita","golondrina")).thenReturn(usuarioMock)
		
		assertEquals (serviceTest.signIn("pepita","golondrina"), usuarioMock)
	}
	
	@Test 
	def test000UnUsuarioNoSeLogueaExitosamente(){
		var retorno= false
		var excepcion = new IncorrectUsernameOrPassword("no va")
		
		when(JDBCUserDAOMock.load("pepita","golondrina")).thenThrow(excepcion)
		try{ serviceTest.signIn("pepita","golondrina")}
		catch(IncorrectUsernameOrPassword e) {retorno= true}
		assertTrue(retorno)
	}
	
	@Test 
	def test000UnUsuarioCambiaSuPasswordALaMismaPasswordQueTeniaAntesYElSistemaLeAvisaQueNoPuede(){
		var retorno= false
		
		try{ serviceTest.changePassword("pepita","golondrina","golondrina")}
		catch(IdenticPasswords e) {retorno= true}
		assertTrue(retorno)
	}
	
	@Test 
	def test000UnUsuarioIntenaCambiarSuPasswordPeroSuNickOContraseñaNoSonCorrectos(){
		var retorno= false
		var excepcion = new IncorrectUsernameOrPassword("no va")
		
		when(JDBCUserDAOMock.load("pepita","golondrina")).thenThrow(excepcion)
		try{ serviceTest.changePassword("pepita","golondrina","euforica")}
		catch(IncorrectUsernameOrPassword e) {retorno= true}
		assertTrue(retorno)
	}
	
	@Test 
	def test000UnUsuarioIntenaCambiarSuPasswordExitosamente(){
		
		when(JDBCUserDAOMock.load("pepita","golondrina")).thenReturn(usuarioMock)
		serviceTest.changePassword("pepita","golondrina","euforica")
		verify(JDBCUserDAOMock).update(usuarioMock)
	}
	
}




