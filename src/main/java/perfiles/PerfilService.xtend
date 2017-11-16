package perfiles

interface PerfilService {
	
	def Publicacion agregarPublicación(String aUser, Publicacion aPublication) 
	
	def Comentario agregarComentario(String aUser, int aPublication, Comentario aComentary)
	
	def void meGusta(String aUser, Integer publicacion)
	
	def void noMeGusta(String aUser,Integer publicacion)
	
	def void meGusta(String aUser, int comentario) 
	
	def void noMeGusta(String aUser, int comentario) 
	
	def int verPerfil(String aUser, String otherUser)
}
