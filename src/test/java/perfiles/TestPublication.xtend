package perfiles

import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*
import aereolinea.Destino
import java.util.UUID

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
		
		publicacion.agregarComentario(unComentario)
		
		assertTrue(publicacion.tieneComentarios)
	}
		
	@Test
	def testUnaNuevaPublicationNoTieneUnComentaryDePedro(){
		
		var aComentary = new Comentary("Pepon","Good el viaje", Visibilidad.SoloAmigos)
		
		assertFalse(publicacion.hasCommentary(aComentary))
	}
	
	@Test
	def testUnaNuevaPublicationTieneUnComentaryDeHunterPepe(){
		
		var aComentary = new Comentary("Pepon","Good el viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		
		publicacion.agregarComentario(aComentary)
		assertTrue(publicacion.hasCommentary(aComentary))
	}
	
	@Test
	def testUnaPublicacionSeInstanciaSinMegusta(){
		
		assertTrue(publicacion.meGustan.empty)
	}
	
	@Test
	def testSeAgregaUnMeGustaAUnaPublicacionYEstaSabeQueLaTiene(){
		
		assertTrue(publicacion.meGustan.empty)
		publicacion.agregarMeGusta("Juan")
		
		assertFalse(publicacion.meGustan.empty)
	}
	
	@Test
	def testUnaPublicacionSeInstanciaSinNoMegusta(){
		
		assertTrue(publicacion.noMeGustan.empty)
	}
	
	@Test
	def testSeAgregaUnNoMeGustaAUnaPublicacionYEstaSabeQueLaTiene(){
		
		assertTrue(publicacion.noMeGustan.empty)
		publicacion.agregarNoMeGusta("Pedro")
		
		assertFalse(publicacion.noMeGustan.empty)
	}
	@Test
	def testSeLeAgregoUnMeGustaPedroYPublicacionSabeSiEsteDioMeGusta(){
		
		assertTrue(publicacion.noMeGustan.empty)
		publicacion.agregarMeGusta("Pedro")
		assertTrue(publicacion.leDioMeGusta("Pedro"))
	}
	
	@Test
	def testSeLeAgregoUnNoMeGustaPedroYPublicacionSabeSiEsteDioNOMeGusta(){
		
		assertTrue(publicacion.noMeGustan.empty)
		publicacion.agregarNoMeGusta("Juan")
		assertTrue(publicacion.leDioNoMeGusta("Juan"))
	}
	
}
