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
		
		comentario.agregar(comentario.meGustan,"Juancho")
		assertFalse(comentario.meGustan.empty)
	}
	@Test
	def testUnComentarioSabeQueJuanchoDioMeGustaEnEste(){
		comentario.agregar(comentario.meGustan,"Juancho")
		assertTrue(comentario.meGustan.contains("Juancho"))
	}
	
	@Test
	def testUnComentarioQuitaElMeGustaDeJuan(){
		comentario.agregar(comentario.meGustan,"Juancho")
		comentario.quitar(comentario.meGustan,"Juancho")
		
		assertFalse(comentario.meGustan.contains("Juancho"))
	}
	
	
	@Test
	def testUnComentarioQueNoTeniaNingunNoMeGustaAgregaUnNoMeGustaDeHaters(){
		assertTrue(comentario.noMeGustan.empty)
		comentario.agregar(comentario.noMeGustan,"Juancho")
		assertFalse(comentario.noMeGustan.empty)
	}

	@Test
	def testUnComentarioSabeQueHatersDioNoMeGusta(){
		comentario.agregar(comentario.noMeGustan,"Haters") 
		assertTrue(comentario.noMeGustan.contains("Haters"))
	}
	
	@Test
	def testUnComentarioQuitaElNoMeGustaDeHaters(){
		comentario.agregar(comentario.noMeGustan,"Haters") 
		comentario.quitar(comentario.noMeGustan,"Haters") 
		assertFalse(comentario.noMeGustan.contains("Haters"))
	}
	
	
	
}
