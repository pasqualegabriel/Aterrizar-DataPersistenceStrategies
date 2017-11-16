package Excepciones

import javax.persistence.NoResultException

class ExceptionNoVisitoDestino extends NoResultException{
	new(String unMensaje){
		super(unMensaje)
	}
}