package perfiles

import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*
import aereolinea.Destino

class TestPublicacion {
	
	Publicacion publicacion
	Comentario  unComentario
	Destino     jamaica
	
	@Before
	def void setUp(){
		jamaica      = new Destino("Jamaica") 
		publicacion  = new Publicacion("Pepita La Loca",Visibilidad.SoloAmigos, jamaica )
	
	}

	@Test
	def testUnaPublicacionSeCreaConUnMensajeYSabeQueLoTiene(){
		var mensaje = "Pepita La Loca"
		
		assertTrue(publicacion.tieneComoMensaje(mensaje))
	}
	
	@Test
	def testUnaPublicacionSeCreaConUnMensajeYSabeQueNoEsOtroDiferente(){
		var mensaje = "Pepe el Sagaz"
		
		assertFalse(publicacion.tieneComoMensaje(mensaje))
	}
	
	
	
	@Test
	def testUnaPublicacionSeInstanciaConUnDestino(){
		
		assertTrue(publicacion.tieneComoDestino(jamaica) )
	}
	
	@Test
	def testUnaPublicacionSeInstanciaConLaVisibilidadSoloAmigos(){
		var visibilidadSoloAmigos = Visibilidad.SoloAmigos
		
		assertTrue(publicacion.tieneComoVisibilidad(visibilidadSoloAmigos) )
	}
	
	@Test
	def testUnaPublicacionQueseInstanciaConVisibilidadComoAmigosSabeQueNoTieneVisibilidadPrivado(){
		var visibilidadPrivado = Visibilidad.Privado
		
		assertFalse(publicacion.tieneComoVisibilidad(visibilidadPrivado) )
	}

	
	@Test
	def testUnaPublicacionSeInstanciaSinComentarios(){
		assertFalse(publicacion.tieneComentarios)
	}
	
	@Test
	def testAlAgregarseUnComentarioUnaPublicacionSabeQueLoTiene(){
		assertFalse(publicacion.tieneComentarios)
		
		unComentario = new Comentario(1,"Pepa",Visibilidad.SoloAmigos,"Juan")
		
		publicacion.agregarComentario(unComentario)
		
		assertTrue(publicacion.tieneComentarios)
	}
	
	@Test
	def testUnaPublicacionSeInstanciaSinMegusta(){
		
		assertFalse(publicacion.tieneMeGusta)
	}
	
	@Test
	def testSeAgregaUnMeGustaAUnaPublicacionYEstaSabeQueLaTiene(){
		assertFalse(publicacion.tieneMeGusta)
		publicacion.agregarMeGusta("Juan")
		
		assertTrue(publicacion.tieneMeGusta)
	}
	
	@Test
	def testUnaPublicacionSeInstanciaSinNoMegusta(){
		
		assertFalse(publicacion.tieneNoMeGusta)
	}
	
	@Test
	def testSeAgregaUnNoMeGustaAUnaPublicacionYEstaSabeQueLaTiene(){
		assertFalse(publicacion.tieneNoMeGusta)
		publicacion.agregarNoMeGusta("Pedro")
		
		assertTrue(publicacion.tieneNoMeGusta)
	}
	@Test
	def testSeLeAgregoUnMeGustaPedroYPublicacionSabeSiEsteDioMeGusta(){
		assertFalse(publicacion.tieneNoMeGusta)
		publicacion.agregarMeGusta("Pedro")
		assertTrue(publicacion.leDioMeGusta("Pedro"))
	}
	
	@Test
	def testSeLeAgregoUnNoMeGustaPedroYPublicacionSabeSiEsteDioNOMeGusta(){
		assertFalse(publicacion.tieneNoMeGusta)
		publicacion.agregarNoMeGusta("Juan")
		assertTrue(publicacion.leDioNoMeGusta("Juan"))
	}
	
}
