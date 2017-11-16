package perfiles

import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*


class TestComentario {
	
	Comentario comentario
	
	@Before
	def void setUp(){
		comentario = new Comentario(1,"Pepita La Loca",Visibilidad.SoloAmigos,"Juan") 
		
	}

	@Test
	def testUnComentarioSeCreaConUnMensajeYSabeQueLoTiene(){
		var mensaje = "Pepita La Loca"
		
		assertTrue(comentario.tieneComoMensaje(mensaje))
	}
	
	@Test
	def testUnComentarioSeCreaConUnMensajeYSabeQueNoEsOtroDiferente(){
		var mensaje = "Pepe el Sagaz"
		
		assertFalse(comentario.tieneComoMensaje(mensaje))
	}
	

	@Test
	def testUnComentarioSeCreaConLaVisibilidadSoloAmigosYSabeQueEsLaVisibilidadQueTiene(){
		
		var visibilidadSoloAmigos = Visibilidad.SoloAmigos
		assertTrue(comentario.tieneComoVisibilidad(visibilidadSoloAmigos))
	}
	
	@Test
	def testUnComentarioSeCreaConLaVisibilidadSoloAmigosYSabeQueNoTieneVisibilidadPrivada(){
		
		var visibilidadPrivado = Visibilidad.Privado
		assertFalse(comentario.tieneComoVisibilidad(visibilidadPrivado))
	}
	
	@Test
	def testUnComentarioQueNoTeniaMeGustaAgregaUnMegustaDeJuancho(){
		assertFalse(comentario.tieneMeGusta)
		
		comentario.agregarMeGusta("Juancho")
		assertTrue(comentario.tieneMeGusta)
	}
	@Test
	def testUnComentarioSabeQueJuanchoDioMeGustaEnEste(){
		comentario.agregarMeGusta("Juancho")
		assertTrue(comentario.leDioMeGusta("Juancho"))
	}
	
	@Test
	def testUnComentarioQueNoTeniaNingunNoMeGustaAgregaUnNoMeGustaDeHaters(){
		assertFalse(comentario.tieneNoMeGusta)
		comentario.agregarNoMeGusta("Haters")
		assertTrue(comentario.tieneNoMeGusta)
	}

	@Test
	def testUnComentarioSabeQueHatersDioNoMeGustaEnEste(){
		comentario.agregarNoMeGusta("Haters") 
		assertTrue(comentario.leDioNoMeGusta("Haters"))
	}
	
	
	
}
