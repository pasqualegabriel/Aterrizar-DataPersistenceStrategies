package perfiles

import java.util.List

import aereolinea.Destino
import org.eclipse.xtend.lib.annotations.Accessors
import org.jongo.marshall.jackson.oid.MongoId
import org.jongo.marshall.jackson.oid.MongoObjectId
import java.util.UUID

@Accessors
class Publication extends Nota{
	
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
	
	def hasCommentary(Comentary aComentary) {
		comentarios.contains(aComentary)
	}
	
	def getIdDestino() {
		destino.id
	}
	
	def searchCommentary(UUID idCommentary) {
		comentarios.findFirst[ commentary | commentary.id.equals(idCommentary)]
	}
	
	
}




