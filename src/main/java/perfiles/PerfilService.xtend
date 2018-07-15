package perfiles

import java.util.UUID

interface PerfilService {
	
	def Publication agregarPublicación(Publication aPublication) 
	
	def Comentary agregarComentario(String aPublication, Comentary aComentary)
	
	def void meGusta(String aUser, String publicacion)
	
	def void noMeGusta(String aUser,String publicacion)
	
	def void meGusta(String aUser, UUID idCommentary) 
	
	def void noMeGusta(String aUser, UUID idCommentary) 
	
	def Profile verPerfil(String aUser, String otherUser)
}
