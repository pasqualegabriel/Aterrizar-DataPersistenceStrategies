package perfiles

class Comentary extends asdasdasd{

	String idPublication
	
	new(){
		
	}
	
	new(String aUserProprietor, String unMensaje, Visibilidad unaVisibilidad) {
		super(aUserProprietor,unMensaje,unaVisibilidad)	
	}
	
	new(String aUserProprietor, String aIdPublication, String unMensaje, Visibilidad unaVisibilidad) {
		super(aUserProprietor,unMensaje,unaVisibilidad)
		idPublication = aIdPublication
	}
	
}
