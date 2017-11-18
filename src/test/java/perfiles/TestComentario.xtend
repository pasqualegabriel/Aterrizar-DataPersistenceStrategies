package perfiles

import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*


class TestComentario {
	
	Comentary comentario
	
	@Before
	def void setUp(){
		comentario = new Comentary("Pepita La Loca","Re cool viaje",Visibilidad.SoloAmigos) 
		
	}

	@Test
	def testUnComentarioSeCreaConUnMensajeYSabeQueLoTiene(){
		var mensaje = "Re cool viaje"
		
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
	def testUnComentarioSabeQueHatersDioNoMeGusta(){
		comentario.agregarNoMeGusta("Haters") 
		assertTrue(comentario.leDioNoMeGusta("Haters"))
	}
	
	
	
}
