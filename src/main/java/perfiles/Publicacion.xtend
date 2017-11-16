package perfiles

import java.util.List

import aereolinea.Destino
import org.eclipse.xtend.lib.annotations.Accessors
import org.jongo.marshall.jackson.oid.MongoId
import org.jongo.marshall.jackson.oid.MongoObjectId

@Accessors
class Publicacion extends asdasdasd{

	@MongoId
	@MongoObjectId
	String     	_id

	List<Comentario> comentarios = newArrayList
	Destino 		 destino
	
	new(){}
	
	new( String unMensaje,Visibilidad unaVisibilidad, Destino unDestino){
		super(unMensaje,unaVisibilidad)

		this.destino     = unDestino

	}
	
	def tieneComentarios() {
		!comentarios.isEmpty
	}
	
	def agregarComentario(Comentario comentario) {
		comentarios.add(comentario)
	}
	
	def tieneComoDestino(Destino unDestino) {
		this.destino.equals(unDestino) 
	}
	
	def getNombreDestino(){
		destino.nombre;
	}
	
	

	

	
	
}
