package perfiles

class Comentario extends asdasdasd{

	String userProprietor
	//Esta Pareciendo que al final, comentario es la clase Abstracta y publicacion extiende de este!
	new(){
		
	}
	
	new(Integer aId, String unMensaje, Visibilidad unaVisibilidad,String aUserProprietor) {
		super(unMensaje,unaVisibilidad)
		userProprietor= aUserProprietor;
	}
	
	
}
