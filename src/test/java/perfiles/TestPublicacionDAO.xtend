package perfiles

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.junit.After
import daoImplementacion.PublicationDAO
import aereolinea.Destino
import java.util.UUID

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
		
		publication.agregar(publication.meGustan,"Juan")
		publication.agregar(publication.noMeGustan,"Pedro")
		publication.cuerpo      = "re Cool el viaje por nordelta re TOOL"
		publication.visibilidad = Visibilidad.Privado
		var aComentary = new Comentary("Pepon","Good el viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)

		publicationDao.update(publication)
		var loadPublicationAfterUpdate = publicationDao.load(publication.id)  
		
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
		
		publicationDao.save(aPublication)
		var loadPublication = publicationDao.load(aPublication.id) 
		assertNotEquals(aPublication,loadPublication)
		assertEquals(aPublication.getAuthor,loadPublication.getAuthor)
		assertEquals(aPublication.visibilidad,loadPublication.visibilidad)
		assertEquals(aPublication.cuerpo,loadPublication.cuerpo)
		assertNotNull(loadPublication.id)
	}
	
	@Test
	def borrar(){

		this.saveAndTestPublication(publication)
		
		publication.agregar(publication.meGustan,"Juan")
		publication.agregar(publication.noMeGustan,"Pedro")
		publication.cuerpo      = "re Cool el viaje por nordelta re TOOL"
		publication.visibilidad = Visibilidad.Privado
		
		var aComentary = new Comentary("Pepon","Good el viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary)

		var aComentary2 = new Comentary("Peponaaaa","Good eldfdfd viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		publication.agregarComentario(aComentary2)

		var publication2 = new Publication("HunterJuan","re COOL el viaje a nordelta",Visibilidad.Publico,new Destino("dfdf"));

		var aComentary3 = new Comentary("Peponaaaa","Good eldfdfd viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		
		var aComentary4 = new Comentary("PUTO","Good eldfdfd viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
		
		publication2.agregarComentario(aComentary3)
		publication2.agregarComentario(aComentary4)
		publicationDao.save(publication2)
		
		publicationDao.update(publication2)
		publicationDao.update(publication)
		var loadPublicationAfterUpdate = publicationDao.load(publication.id)  
		var loadPublicationAfterUpdate2 = publicationDao.load(publication2.id) 
		
		assertNotEquals(publication,loadPublicationAfterUpdate)
		assertEquals(publication.getAuthor,loadPublicationAfterUpdate.getAuthor)
		assertEquals(publication.visibilidad,loadPublicationAfterUpdate.visibilidad)
		assertEquals(publication.cuerpo,loadPublicationAfterUpdate.cuerpo)
		assertTrue(loadPublicationAfterUpdate.meGustan.contains("Juan"));
		assertTrue(loadPublicationAfterUpdate.noMeGustan.contains("Pedro"))
		assertTrue(loadPublicationAfterUpdate.hasCommentary(aComentary))
		assertEquals(publication.id, loadPublicationAfterUpdate.id)
		
		var pub= publicationDao.loadForCommentary(aComentary4.id)
		assertEquals(pub.id,loadPublicationAfterUpdate2.id)
		
	}
	
	@Test
	def te(){
		publicationDao.deleteAll
		assertEquals(1,1)
	}
	
	@After
	def void tearDown(){
		//publicationDao.deleteAll
		
	}
}