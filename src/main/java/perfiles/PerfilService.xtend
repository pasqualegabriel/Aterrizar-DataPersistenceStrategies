package perfiles

interface PerfilService {
	
	def Publication agregarPublicación(String aUser, Publication aPublication) 
	
	def Comentary agregarComentario(String aUser, int aPublication, Comentary aComentary)
	
	def void meGusta(String aUser, Integer publicacion)
	
	def void noMeGusta(String aUser,Integer publicacion)
	
	def void meGusta(String aUser, int comentario) 
	
	def void noMeGusta(String aUser, int comentario) 
	
	def int verPerfil(String aUser, String otherUser)
}
