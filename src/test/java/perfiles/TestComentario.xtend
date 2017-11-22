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
	def testUnComentarioQueNoTeniaMeGustaAgregaUnMegustaDeJuancho(){
		assertTrue(comentario.meGustan.empty)
		
		comentario.agregarMeGusta("Juancho")
		assertFalse(comentario.meGustan.empty)
	}
	@Test
	def testUnComentarioSabeQueJuanchoDioMeGustaEnEste(){
		comentario.agregarMeGusta("Juancho")
		assertTrue(comentario.meGustan.contains("Juancho"))
	}
	
	@Test
	def testUnComentarioQuitaElMeGustaDeJuan(){
		comentario.agregarMeGusta("Juancho")
		comentario.quitarMeGusta( "Juancho")
		
		assertFalse(comentario.meGustan.contains("Juancho"))
	}
	
	
	@Test
	def testUnComentarioQueNoTeniaNingunNoMeGustaAgregaUnNoMeGustaDeHaters(){
		assertTrue(comentario.noMeGustan.empty)
		comentario.agregarNoMeGusta("Juancho")
		assertFalse(comentario.noMeGustan.empty)
	}

	@Test
	def testUnComentarioSabeQueHatersDioNoMeGusta(){
		comentario.agregarNoMeGusta("Haters") 
		assertTrue(comentario.noMeGustan.contains("Haters"))
	}
	
	@Test
	def testUnComentarioQuitaElNoMeGustaDeHaters(){
		comentario.agregarNoMeGusta("Haters") 
		comentario.quitarNoMeGusta("Haters") 
		assertFalse(comentario.noMeGustan.contains("Haters"))
	}
	
	
	
}
