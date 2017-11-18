package perfiles

import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*
import aereolinea.Destino

class TestPublication {
	
	Publication publicacion
	Comentary   unComentario
	Destino     jamaica
	
	@Before
	def void setUp(){
		jamaica      = new Destino("Jamaica") 
		publicacion  = new Publication("Juan","Pepita La Loca",Visibilidad.SoloAmigos,jamaica)
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
		
		unComentario = new Comentary("Pepe","RE COOl el viaje",Visibilidad.SoloAmigos)
		
		publicacion.agregarComentario("HunterPepe")
		
		assertTrue(publicacion.tieneComentarios)
	}
		
	@Test
	def testUnaNuevaPublicationNoTieneUnComentaryDePedro(){
		
		assertFalse(publicacion.hasCommentary("idComentaryHunterPedro"))
	}
	
	@Test
	def testUnaNuevaPublicationTieneUnComentaryDeHunterPepe(){
		
		publicacion.agregarComentario("idComentaryHunterPedro")
		assertTrue(publicacion.hasCommentary("idComentaryHunterPedro"))
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
