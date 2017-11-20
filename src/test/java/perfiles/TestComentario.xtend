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
		assertTrue(comentario.meGustan.empty)
		
		comentario.agregarMeGusta("Juancho")
		assertFalse(comentario.meGustan.empty)
	}
	@Test
	def testUnComentarioSabeQueJuanchoDioMeGustaEnEste(){
		comentario.agregarMeGusta("Juancho")
		assertTrue(comentario.leDioMeGusta("Juancho"))
	}
	
	@Test
	def testUnComentarioQueNoTeniaNingunNoMeGustaAgregaUnNoMeGustaDeHaters(){
		assertTrue(comentario.noMeGustan.empty)
		comentario.agregarNoMeGusta("Haters")
		assertFalse(comentario.noMeGustan.empty)
	}

	@Test
	def testUnComentarioSabeQueHatersDioNoMeGusta(){
		comentario.agregarNoMeGusta("Haters") 
		assertTrue(comentario.leDioNoMeGusta("Haters"))
	}
	
	
	
}
