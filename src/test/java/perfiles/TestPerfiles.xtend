package perfiles

import org.junit.Before
import org.junit.Test

import service.User
import static org.junit.Assert.*
import aereolinea.Destino
import service.Profile

class TestPerfiles {
	
	User    	pepita
	Profile  	unPerfil
	Publicacion unaPublicacion	
	@Before
	def void setUp(){
		pepita 		   = new User("pepita")
		unPerfil 	   = new Profile(pepita.userName)
		unaPublicacion = new Publicacion("unMensaje",Visibilidad.SoloAmigos, new Destino)
	}

	@Test
	def testUnPerfilPerteneceAlUsuarioPepita(){
		
		assertTrue(unPerfil.tieneComoUsuario(pepita.userName))
	}
	
	@Test
	def testSeAgregaUnaPublicacionAlPerfilDePepitaYElPerfilDePepitaSabeQueTieneUnaPublicacion(){
		
		unPerfil.publicar(unaPublicacion)
		
		assertTrue(unPerfil.tienePublicacion(unaPublicacion))
	}
	
		
	@Test
	def testUnPerfilSabeQueNoTieneUnaPublicacionQueNoSePublico(){
	
		assertFalse(unPerfil.tienePublicacion(unaPublicacion))
	}
	
	
}
