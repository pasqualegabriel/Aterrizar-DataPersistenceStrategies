package perfiles

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.junit.After
import daoImplementacion.PublicationDAO
import aereolinea.Destino

class TestPublicacionDAO {
	
	PublicationDAO publicationDao
	Publication	   publication

	@Before
	def void setUp(){
		var	destino    = new Destino("Nordelta") => [ id = 1 ]
		publicationDao = new PublicationDAO
		publication    = new Publication("HunterJuan","re COOL el viaje a nordelta",Visibilidad.Publico,destino);
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
		var aComentary = new Comentary("Pepon","Good el viaje", Visibilidad.SoloAmigos)
		publication.agregarComentario(aComentary)
		
		publicationDao.update(publication)
		var loadPublicationAfterUpdate = publicationDao.load(publication.id)  
		
		assertNotEquals(publication,loadPublicationAfterUpdate)
		assertEquals(publication.getAuthor,loadPublicationAfterUpdate.getAuthor)
		assertEquals(publication.visibilidad,loadPublicationAfterUpdate.visibilidad)
		assertEquals(publication.cuerpo,loadPublicationAfterUpdate.cuerpo)
		assertTrue(loadPublicationAfterUpdate.leDioMeGusta("Juan"));
		assertTrue(loadPublicationAfterUpdate.leDioNoMeGusta("Pedro"))
		assertTrue(loadPublicationAfterUpdate.hasCommentary(aComentary.id))
		assertEquals(publication.id, loadPublicationAfterUpdate.id)
	}
	
	def void saveAndTestPublication(Publication aPublication){
		
		publicationDao.save(aPublication)
		var loadPublication = publicationDao.load(aPublication.id) 
		assertNotEquals(aPublication,loadPublication)
		assertEquals(aPublication.getAuthor,loadPublication.getAuthor)
		assertEquals(aPublication.visibilidad,loadPublication.visibilidad)
		assertEquals(aPublication.cuerpo,loadPublication.cuerpo)
		assertNotNull(loadPublication.id)
	}
	
	@After
	def void tearDown(){
		publicationDao.deleteAll
		
	}
}