package Excepciones

class ExceptionNoTienePermisoParaInteractuarConElComentario  extends RuntimeException {
	new(String unMensaje){
		super(unMensaje)
	}
}