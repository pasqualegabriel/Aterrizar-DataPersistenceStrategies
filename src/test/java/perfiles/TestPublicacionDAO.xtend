package perfiles

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.junit.After
import daoImplementacion.PublicationDAO
import aereolinea.Destino
import java.util.UUID

class TestPublicacionDAO {
	
	PublicationDAO publicationDAO
	Publication	   publication
	Destino        destino

	@Before
	def void setUp(){
		destino        = new Destino("Nordelta") => [ id = 1 ]
		publicationDAO = new PublicationDAO
		publication    = new Publication("HunterJuan", "re COOL el viaje a nordelta", Visibilidad.Publico, destino)
	}
	
	@Test
	def testUnaPublicationDaoPersisteUnPublication(){

		this.saveAndTestPublication(publication)
	}
	
	@Test
	def testUnaPublicationDaoUpdateaUnaPublicationQueYaPersistio(){

		this.saveAndTestPublication(publication)
		
		publication.agregarMeGusta("Juan")
		publication.agregarNoMeGusta("Pedro")
		publication.cuerpo      = "re Cool el viaje por nordelta re TOOL"
		publication.visibilidad = Visibilidad.Privado
		var aComentary = new Comentary("Pepon","Good el viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)

		publicationDAO.update(publication)
		var loadPublicationAfterUpdate = publicationDAO.load(publication.id)  
		
		assertNotEquals(publication,loadPublicationAfterUpdate)
		assertEquals(publication.getAuthor,loadPublicationAfterUpdate.getAuthor)
		assertEquals(publication.visibilidad,loadPublicationAfterUpdate.visibilidad)
		assertEquals(publication.cuerpo,loadPublicationAfterUpdate.cuerpo)
		assertTrue(loadPublicationAfterUpdate.meGustan.contains("Juan"));
		assertTrue(loadPublicationAfterUpdate.noMeGustan.contains("Pedro"))
		assertTrue(loadPublicationAfterUpdate.hasCommentary(aComentary))
		assertEquals(publication.id, loadPublicationAfterUpdate.id)
	}
	
	def void saveAndTestPublication(Publication aPublication){
		
		publicationDAO.save(aPublication)
		var loadPublication = publicationDAO.load(aPublication.id) 
		assertNotEquals(aPublication,loadPublication)
		assertEquals(aPublication.getAuthor,loadPublication.getAuthor)
		assertEquals(aPublication.visibilidad,loadPublication.visibilidad)
		assertEquals(aPublication.cuerpo,loadPublication.cuerpo)
		assertNotNull(loadPublication.id)
	}

    @Test
	def seVerificaQueYaSePublicoUnaPublicacion(){
		
		publicationDAO.save(publication)
		assertTrue(publicationDAO.hayPublicacion(publication))
	}

    @Test
	def seVerificaQueNoSePublicoUnaPublicacion(){
		
		assertFalse(publicationDAO.hayPublicacion(publication))

		publicationDAO.save(publication)

        var newPublication = new Publication("HunterJuan", "Buen viaje", Visibilidad.Publico, new Destino("Roma"))
		assertFalse(publicationDAO.hayPublicacion(newPublication))

		var otherNewPublication = new Publication("Pedro", "Gran viaje", Visibilidad.Publico, destino)
		assertFalse(publicationDAO.hayPublicacion(otherNewPublication))
	}
	
    @Test
	def seAgregaUnComentarioAUnaPublicacion(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("Pedro", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.hasCommentary(aComentary))
	}

	@Test
	def seAgregaYSeQuitaUnMeGustaAUnaPublicacion(){
		
		publicationDAO.save(publication)

		publicationDAO.agregarMeGustaPublicacion(publication.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.meGustan.contains("Eze"))
		
		publicationDAO.quitarMeGustaPublicacion( publication.id, "Eze")
		aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.meGustan.contains("Eze"))
	}
	
	@Test
	def seAgreganDosMeGustaAUnaPublicacionPeroSoloSeGuardaUnaVez(){
		
		publicationDAO.save(publication)

		publicationDAO.agregarMeGustaPublicacion(publication.id, "Eze")
		publicationDAO.agregarMeGustaPublicacion(publication.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.meGustan.contains("Eze"))
		assertEquals(1, aPublication.meGustan.size)
	}
	
	@Test
	def seQuitaUnMeGustaDeUnaPublicacionSinMeGustan(){
		
		publicationDAO.save(publication)

		publicationDAO.quitarMeGustaPublicacion(publication.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.meGustan.contains("Eze"))
		assertTrue(aPublication.meGustan.empty)
	}
	
	@Test
	def seAgregaYSeQuitaUnNoMeGustaAUnaPublicacion(){
		
		publicationDAO.save(publication)

		publicationDAO.agregarNoMeGustaPublicacion(publication.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.noMeGustan.contains("Eze"))
		
		publicationDAO.quitarNoMeGustaPublicacion( publication.id, "Eze")
		aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.noMeGustan.contains("Eze"))
	}
	
	@Test
	def seAgreganDosNoMeGustaAUnaPublicacionPeroSoloSeGuardaUnaVez(){
		
		publicationDAO.save(publication)

		publicationDAO.agregarNoMeGustaPublicacion(publication.id, "Eze")
		publicationDAO.agregarNoMeGustaPublicacion(publication.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.noMeGustan.contains("Eze"))
		assertEquals(1, aPublication.noMeGustan.size)
	}
	
	@Test
	def seQuitaUnNoMeGustaDeUnaPublicacionSinNoMeGustan(){
		
		publicationDAO.save(publication)

		publicationDAO.quitarNoMeGustaPublicacion(publication.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.noMeGustan.contains("Eze"))
		assertTrue(aPublication.noMeGustan.empty)
	}
	
	@Test
	def seAgregaYSeQuitaUnMeGustaAUnComentario(){
		
		var aComentary = new Comentary("Pedro", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)
		publicationDAO.save(publication)

		publicationDAO.agregarMeGustaComentario(aComentary.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.searchCommentary(aComentary.id).meGustan.contains("Eze"))
		
		publicationDAO.quitarMeGustaComentario( aComentary.id, "Eze")
		aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.searchCommentary(aComentary.id).meGustan.contains("Eze"))
	}
	
	@Test
	def seAgreganDosMeGustaAUnComentarioDePedroPeroSoloSeGuardaUnaVez(){
		
		var aComentary = new Comentary("Pedro", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)
		publicationDAO.save(publication)

		publicationDAO.agregarMeGustaComentario(aComentary.id, "Eze")
		publicationDAO.agregarMeGustaComentario(aComentary.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.searchCommentary(aComentary.id).meGustan.contains("Eze"))
		assertEquals(1, aPublication.searchCommentary(aComentary.id).meGustan.size)
	}
	
	@Test
	def seQuitaUnMeGustaDeUnComentarioSinMeGustan(){
		
		var aComentary = new Comentary("Pedro", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)
		publicationDAO.save(publication)

		publicationDAO.quitarMeGustaComentario(aComentary.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.searchCommentary(aComentary.id).meGustan.contains("Eze"))
		assertTrue(aPublication.searchCommentary(aComentary.id).meGustan.empty)
	}
	
	@Test
	def seAgregaYSeQuitaUnNoMeGustaAUnComentario(){
		
		var aComentary = new Comentary("Pedro", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)
		publicationDAO.save(publication)

		publicationDAO.agregarNoMeGustaComentario(aComentary.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.searchCommentary(aComentary.id).noMeGustan.contains("Eze"))
		
		publicationDAO.quitarNoMeGustaComentario( aComentary.id, "Eze")
		aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.searchCommentary(aComentary.id).noMeGustan.contains("Eze"))
	}
	
	@Test
	def seAgreganDosNoMeGustaAUnComentarioPeroSoloSeGuardaUnaVez(){
		
		var aComentary = new Comentary("Pedro", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)
		publicationDAO.save(publication)

		publicationDAO.agregarNoMeGustaComentario(aComentary.id, "Eze")
		publicationDAO.agregarNoMeGustaComentario(aComentary.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertTrue(aPublication.searchCommentary(aComentary.id).noMeGustan.contains("Eze"))
		assertEquals(1, aPublication.searchCommentary(aComentary.id).noMeGustan.size)
	}
	
	@Test
	def seQuitaUnNoMeGustaDeUnComentarioSinNoMeGustan(){
		
		var aComentary = new Comentary("Pedro", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)
		publicationDAO.save(publication)

		publicationDAO.quitarNoMeGustaComentario(aComentary.id, "Eze")
		var aPublication = publicationDAO.load(publication.id)

		assertFalse(aPublication.searchCommentary(aComentary.id).noMeGustan.contains("Eze"))
		assertTrue(aPublication.searchCommentary(aComentary.id).noMeGustan.empty)
	}
	
	@Test
	def elUsuarioHunterJuanTienePermisosParaInteractuarConSuPublicacionPublica(){
		
		publicationDAO.save(publication)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "HunterJuan", #[]))
	}
	
	@Test
	def elUsuarioJoseTienePermisosParaInteractuarConLaPublicacionPublicaDeHunterJuan(){
		
		publicationDAO.save(publication)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "Jose", #[]))
	}
	
	@Test
	def elUsuarioJoseAmigoDeHunterJuanTienePermisosParaInteractuarConLaPublicacionPublicaDeHunterJuan(){
		
		publicationDAO.save(publication)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "Jose", #["HunterJuan"]))
	}
	
	@Test
	def elUsuarioJoseAmigoDeHunterJuanTienePermisosParaInteractuarConLaPublicacionSoloAmigosDeHunterJuan(){
		
		publication.visibilidad = Visibilidad.SoloAmigos
		publicationDAO.save(publication)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "Jose", #["HunterJuan"]))
	}
	
	@Test
	def elUsuarioHunterJuanTienePermisosParaInteractuarConSuPublicacionSoloAmigos(){
		
		publication.visibilidad = Visibilidad.SoloAmigos
		publicationDAO.save(publication)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "HunterJuan", #["Pepita"]))
	}
	
	@Test
	def elUsuarioJoseNoTienePermisosParaInteractuarConLaPublicacionSoloAmigosDeHunterJuan(){
		
		publication.visibilidad = Visibilidad.SoloAmigos
		publicationDAO.save(publication)

		assertFalse(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "Jose", #["Pepita"]))
	}
	
	@Test
	def elUsuarioHunterJuanTienePermisosParaInteractuarConSuPublicacionPrivada(){
		
		publication.visibilidad = Visibilidad.Privado
		publicationDAO.save(publication)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "HunterJuan", #["Pepita"]))
	}
	
	@Test
	def elUsuarioJoseAmigoDeHunterJuanNoTienePermisosParaInteractuarConLaPublicacionPrivadaDeHunterJuan(){
		
		publication.visibilidad = Visibilidad.Privado
		publicationDAO.save(publication)

		assertFalse(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "Jose", #["HunterJuan"]))
	}
	
	@Test
	def elUsuarioJoseNoTienePermisosParaInteractuarConLaPublicacionPrivadaDeHunterJuan(){
		
		publication.visibilidad = Visibilidad.Privado
		publicationDAO.save(publication)

		assertFalse(publicationDAO.tienePermisosParaInteractuarConLaPublicacion(publication.id, "Jose", #["Pepita"]))
	}
	


	@Test
	def elUsuarioHunterJuanTienePermisosParaInteractuarConSuComentarioPublico(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("HunterJuan", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "HunterJuan", #[]))
	}
	
	@Test
	def elUsuarioJoseTienePermisosParaInteractuarConElComentarioPublicoDePepita(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("Pepita", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "Jose", #[]))
	}
	
	@Test
	def elUsuarioJoseAmigoDeHunterJuanTienePermisosParaInteractuarConElComentarioPublicoDePepita(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("Pepita", "cool", Visibilidad.Publico) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "Jose", #["HunterJuan"]))
	}
	
	@Test
	def elUsuarioJoseAmigoDeHunterJuanTienePermisosParaInteractuarConElComentarioSoloAmigosDeHunterJuan(){
		
		publication.visibilidad = Visibilidad.SoloAmigos
		publicationDAO.save(publication)
		var aComentary = new Comentary("HunterJuan", "cool", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "Jose", #["HunterJuan"]))
	}
	
	@Test
	def elUsuarioHunterJuanTienePermisosParaInteractuarConSuComentarioSoloAmigos(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("HunterJuan", "cool", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "HunterJuan", #["Pepita"]))
	}
	
	@Test
	def elUsuarioJoseNoTienePermisosParaInteractuarConElComentarioSoloAmigosDeHunterJuan(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("HunterJuan", "cool", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertFalse(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "Jose", #["Pepita"]))
	}
	
	@Test
	def elUsuarioHunterJuanTienePermisosParaInteractuarConSuComentarioPrivado(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("HunterJuan", "cool", Visibilidad.Privado) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertTrue(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "HunterJuan", #["Pepita"]))
	}
	
	@Test
	def elUsuarioJoseAmigoDeHunterJuanNoTienePermisosParaInteractuarConElComentarioPrivadoDeHunterJuan(){
		
		publication.visibilidad = Visibilidad.Privado
		publicationDAO.save(publication)
		var aComentary = new Comentary("HunterJuan", "cool", Visibilidad.Privado) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertFalse(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "Jose", #["HunterJuan"]))
	}

	@Test
	def elUsuarioJoseNoTienePermisosParaInteractuarConElComentarioPrivadoDeHunterJuan(){
		
		publicationDAO.save(publication)
		var aComentary = new Comentary("HunterJuan", "cool", Visibilidad.Privado) => [ id = UUID.randomUUID ]
		publicationDAO.addComment(publication.id, aComentary)

		assertFalse(publicationDAO.tienePermisosParaInteractuarConElComentario(aComentary.id, "Jose", #["Pepita"]))
	}
	
	@After
	def void tearDown(){
		publicationDAO.deleteAll
		
	}
}



