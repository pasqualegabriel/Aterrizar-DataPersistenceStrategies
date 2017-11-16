package perfiles

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.junit.After
import daoImplementacion.PublicationDAO
import aereolinea.Destino

class TestPublicacionDAO {
	
	PublicationDAO 		   publicationDao
	static Publication	   publication

	
	@Before
	def void setUp(){
		var	destino    = 	new Destino("Nordelta")
		destino.id=1
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
		publication.cuerpo = "re Cool el viaje por nordelta re TOOL"
		publication.visibilidad = Visibilidad.Privado
		
		publicationDao.update(publication)
		var loadPublicationAfterUpdate=publicationDao.load(publication.id)  
		
		assertNotEquals(publication,loadPublicationAfterUpdate)
		assertEquals(publication.userProprietor,loadPublicationAfterUpdate.userProprietor)
		assertEquals(publication.visibilidad,loadPublicationAfterUpdate.visibilidad)
		assertEquals(publication.cuerpo,loadPublicationAfterUpdate.cuerpo)
		assertTrue(loadPublicationAfterUpdate.leDioMeGusta("Juan"));
		assertTrue(loadPublicationAfterUpdate.leDioNoMeGusta("Pedro"))
		
		assertEquals(publication.id, loadPublicationAfterUpdate.id)
		
	}
	
	def void saveAndTestPublication(Publication aPublication){
		publicationDao.save(aPublication)
		var loadPublication=publicationDao.load(aPublication.id) 
		assertNotEquals(aPublication,loadPublication)
		assertEquals(aPublication.userProprietor,loadPublication.userProprietor)
		assertEquals(aPublication.visibilidad,loadPublication.visibilidad)
		assertEquals(aPublication.cuerpo,loadPublication.cuerpo)
		assertNotNull(loadPublication.id)
	}
	
	@After
	def void tearDown(){
		publicationDao.deleteAll
		
	}
}