package perfiles

import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.junit.After
import service.Profile
import aereolinea.Destino
import daoImplementacion.ProfileDAO

class TestPerfilDAO {
	
	ProfileDAO 				 perfilDAO
	Profile   			     profile
	Publicacion				 publicacion	
	Comentario				 comentario

	@Before
	def void setUp(){
		
		perfilDAO = new ProfileDAO()
		profile   = new Profile("PepitaUser")
		
		/** Creo un profile con una publicacion y luego la persisto */
		publicacion = new Publicacion("re COOL el viaje a nordelta",Visibilidad.Publico ,new Destino("Nordelta"));
		publicacion.agregarMeGusta("Juan")
		
		profile.publicar(publicacion)
		comentario = new Comentario(1,"Genial la publicacion",Visibilidad.Publico,"Juan")
		comentario.agregarNoMeGusta("haters")
		publicacion.agregarComentario(comentario)
//		perfilDAO.save(profile)
	}
	
	@Test
	def void testUnProfileDaoSabeGuardarUnProfile(){
		var aProfile = perfilDAO.load(profile.usuario)
		assertNotNull(profile.id)
		assertEquals("PepitaUser", aProfile.usuario)

	}
	@Test
	def void testunProfileDaoSabeUpdatearDeSuProfileSuPublicacionDeLaBaseDT(){
		perfilDAO.update(profile)
		var aProfile = perfilDAO.load(profile.usuario)
		assertEquals(1,aProfile.publicaciones.size)


		assertTrue(aProfile.publicaciones.stream.anyMatch[ it.cuerpo.equals(publicacion.cuerpo) && it.leDioMeGusta("Juan")])
		assertFalse(aProfile.publicaciones.stream.anyMatch[it._id !=  null])
		
	}

	@Test
	def void testunProfileDaoSabeUpdatearDeSuProfileLosComentariosDeLaPublicacionDelDestinoNordeltaDeLaBaseDT(){
		perfilDAO.update(profile)
		var aProfile = perfilDAO.load(profile.usuario)
		assertTrue(aProfile.publicaciones.stream.anyMatch[publicacion |publicacion.comentarios.stream.anyMatch
														 [coment|coment.cuerpo.equals(comentario.cuerpo) && coment.leDioNoMeGusta("haters")]
		])

		
	}

//	@Test
//	def void limpiarBAse(){
//		perfilDAO.deleteAll
//		assertTrue(true)
//	}
	
	@After
	def void tearDown(){
		perfilDAO.deleteAll
	}
	
	
	

	
}