package service

import java.util.List
import perfiles.Publicacion
import org.eclipse.xtend.lib.annotations.Accessors
import org.jongo.marshall.jackson.oid.MongoId
import org.jongo.marshall.jackson.oid.MongoObjectId

@Accessors
class Profile {
	
	@MongoId
	@MongoObjectId
	String id
	
	List<Publicacion> publicaciones = newArrayList
	String            usuario 
	
	new(){
		super()
	}
	
	new(String userName){
		super()
		usuario = userName
	}
	
	def publicar(Publicacion publicacion) {
		publicaciones.add(publicacion)
	}
	
	def tienePublicacion(Publicacion unaPublicacion) {
		this.publicaciones.contains(unaPublicacion)
	}
	
	def tieneComoUsuario(String unUserName) {
		usuario.equals(unUserName)
	}
	
}