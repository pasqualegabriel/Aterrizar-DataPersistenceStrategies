package perfiles

import java.util.List

import aereolinea.Destino
import org.eclipse.xtend.lib.annotations.Accessors
import org.jongo.marshall.jackson.oid.MongoId
import org.jongo.marshall.jackson.oid.MongoObjectId
import java.util.UUID

@Accessors
class Publication extends asdasdasd{
	
	@MongoId
	@MongoObjectId
	String     		id
	List<Comentary> comentarios = newArrayList
	Destino 	    destino
	
	new(){}
	
	new(String author, String unMensaje,Visibilidad unaVisibilidad, Destino unDestino){
		super(author,unMensaje,unaVisibilidad)
		this.destino = unDestino
	}
	
	def tieneComentarios() {
		!comentarios.isEmpty
	}
	
	def agregarComentario(Comentary aComentary) {
		comentarios.add(aComentary)
	}
	
	def tieneComoDestino(Destino unDestino) {
		destino.equals(unDestino) 
	}
	
	def getNombreDestino(){
		destino.nombre
	}
	
	def hasCommentary(UUID idCommentary) {
		comentarios.stream.anyMatch[ it.id == idCommentary ]
	}
	
	def getIdDestino() {
		destino.id
	}
	
	

	

	
	
}
