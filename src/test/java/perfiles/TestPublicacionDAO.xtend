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
		
		publication.agregarMeGusta("Juan")
		publication.agregarNoMeGusta("Pedro")
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
	
//	@Test
//	def perfilPrueba(){
//
//		this.saveAndTestPublication(publication)
//		
//		publication.agregarMeGusta("Juan")
//		publication.agregarNoMeGusta("Pedro")
//		publication.cuerpo      = "re Cool el viaje por nordelta re TOOL"
//		publication.visibilidad = Visibilidad.Privado
//		
//		var aComentary = new Comentary("Pepon","Good el viaje", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
//		publication.agregarComentario(aComentary)
//
//		var aComentary2 = new Comentary("Pepin","Good travel", Visibilidad.SoloAmigos)  => [ id = UUID.randomUUID ]
//		publication.agregarComentario(aComentary2)
//
//		var publication2 = new Publication("Nahu","re cool",Visibilidad.Privado,new Destino("dfdf"))
//
//		var aComentary3 = new Comentary("Pipa","Good 1", Visibilidad.Publico)    => [ id = UUID.randomUUID ]
//		
//		var aComentary4 = new Comentary("Pipi","Good 2", Visibilidad.Privado)    => [ id = UUID.randomUUID ]
//		
//		var aComentary5 = new Comentary("Popo","Good 3", Visibilidad.SoloAmigos) => [ id = UUID.randomUUID ]
//		
//		var aComentary6 = new Comentary("Pepi","Good 4", Visibilidad.Privado)    => [ id = UUID.randomUUID ]
//		
//		publication2.agregarComentario(aComentary3)
//		publication2.agregarComentario(aComentary4)
//		publication2.agregarComentario(aComentary5)
//		publication2.agregarComentario(aComentary6)
//		publicationDao.save(publication2)
//		
//		publicationDao.update(publication2)
//		publicationDao.update(publication)
////		var loadPublicationAfterUpdate = publicationDao.load(publication.id)  
////		var loadPublicationAfterUpdate2 = publicationDao.load(publication2.id) 
//		
////		assertNotEquals(publication,loadPublicationAfterUpdate)
////		assertEquals(publication.getAuthor,loadPublicationAfterUpdate.getAuthor)
////		assertEquals(publication.visibilidad,loadPublicationAfterUpdate.visibilidad)
////		assertEquals(publication.cuerpo,loadPublicationAfterUpdate.cuerpo)
////		assertTrue(loadPublicationAfterUpdate.meGustan.contains("Juan"));
////		assertTrue(loadPublicationAfterUpdate.noMeGustan.contains("Pedro"))
////		assertTrue(loadPublicationAfterUpdate.hasCommentary(aComentary))
////		assertEquals(publication.id, loadPublicationAfterUpdate.id)
//		
////		var pub= publicationDao.loadForCommentary(aComentary4.id)
////		assertEquals(pub.id,loadPublicationAfterUpdate2.id)
//		
////		val perfilService 			= new ProfileService(new PublicationDAO, new HibernateUserDAO)
////		var perfil = perfilService.verPerfil("","")
////		
////		assertEquals(1, perfil.publications.size)
////		assertEquals(2, perfil.publications.get(0).comentarios.size)
////		publicationDao.agregarMeGustaPublicacion(publication2.id, "nahui")
////		publicationDao.quitarMeGustaPublicacion( publication2.id, "nahui")
//		assertEquals(1,1)
////		publicationDao.agregarMeGustaComentario(aComentary6.id, "nahui")
////		publicationDao.quitarMeGustaComentario( aComentary6.id, "nahui")
////		var r = publicationDao.loadWithOnlyTheVisibilityAndTheAuthor(publication2.id)
////		assertNotNull(r)
//        val profileService = new ProfileService(publicationDao, new HibernateUserDAO)
//        profileService.agregarMeGusta(publication2.id, "nahuelito")
//
//		var publicacion = publicationDao.load(publication2.id)
//
//		// Assertion
//		assertTrue(publicacion.meGustan.contains("nahuelito"))
//	}
//	
//	@Test
//	def borrar(){
//		publicationDao.deleteAll
//		assertEquals(1,1)
//	}
	
	@After
	def void tearDown(){
		publicationDao.deleteAll
		
	}
}