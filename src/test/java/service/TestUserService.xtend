package service

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import static org.mockito.Mockito.*
import java.time.LocalDateTime
import org.mockito.MockitoAnnotations
import org.mockito.Mock
import userDAO.JDBCUserDAO
import java.util.Date

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

		when(JDBCUserDAOMock.load("PepitaUser","pepita@gmail.com")).thenReturn(usuarioMock)
		
		assertTrue(serviceTest.existeUsuarioCon("PepitaUser", "pepita@gmail.com"))
		
	}	
	
	@Test
	def test000UnServiceSabeQueNoExisteUnUsuarioConNombreyMail(){

		var excepcion = new RuntimeException 

		when(JDBCUserDAOMock.load("PepitaUser","pepita@gmail.com")).thenThrow(excepcion)
		
		assertFalse(serviceTest.existeUsuarioCon("PepitaUser", "pepita@gmail.com"))
	}	
	

	@Test
	def test000SeRegistraUnUsuarioConNombrePepitaExitosamente(){
		
		var excepcion = new RuntimeException 
		
		when(JDBCUserDAOMock.load("3","4")).thenThrow(excepcion)
		var pepita =serviceTest.singUp("1","2","3","4","5")
		
	    verify(JDBCUserDAOMock, times(1)).save(pepita)
	}
	
	@Test (expected=typeof(RuntimeException))
	def test000NoSeRegistraUnUsuarioConNombrePepitaExitosamente(){
		
		when(JDBCUserDAOMock.load("3","4")).thenReturn(usuarioMock)
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
	
}




