package mailSender

import Excepciones.SendMailException

class Postman implements EmailService {
	
	
	override void send(Mail aMail){
	try{
		
		
		
	}catch(RuntimeException e ){ throw new SendMailException("No se pudo enviar el mail")}	
		
	}
}