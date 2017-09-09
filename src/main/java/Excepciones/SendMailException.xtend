package Excepciones

class SendMailException  extends RuntimeException {
		
	new(String message) {
		super(message)
	}
}