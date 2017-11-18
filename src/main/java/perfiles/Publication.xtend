package perfiles

import java.util.List

import aereolinea.Destino
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Publication extends asdasdasd{
			
	List<String>     comentarios = newArrayList
	Destino 		 destino
	
	new(){}
	
	new( String aUserPropietor , String unMensaje,Visibilidad unaVisibilidad, Destino unDestino){
		super(aUserPropietor,unMensaje,unaVisibilidad)
		this.destino    = unDestino
	}
	
	def tieneComentarios() {
		!comentarios.isEmpty
	}
	
	def agregarComentario(String idComentary) {
		comentarios.add(idComentary)
	}
	
	def tieneComoDestino(Destino unDestino) {
		this.destino.equals(unDestino) 
	}
	
	def getNombreDestino(){
		destino.nombre
	}
	
	def hasCommentary(String idCommentary) {
		comentarios.contains(idCommentary)
	}
	
	def getIdDestino() {
		destino.id
	}
	
	

	

	
	
}
