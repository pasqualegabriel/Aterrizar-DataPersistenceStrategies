package perfiles

interface PerfilService {
	
	def Publication agregarPublicación(String aUser, Publication aPublication) 
	
	def Comentary agregarComentario(String aPublication, Comentary aComentary)
	
	def void meGusta(String aUser, String publicacion)
	
	def void noMeGusta(String aUser,String publicacion)
	
	def void meGustaComentario(String aUser, String comentario) 
	
	def void noMeGustaComentario(String aUser, String comentario) 
	
	def int verPerfil(String aUser, String otherUser)
}
