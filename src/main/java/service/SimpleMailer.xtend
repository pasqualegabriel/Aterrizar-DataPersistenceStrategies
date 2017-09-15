package service

import mailSender.Mail

class SimpleMailer implements MailGenerator {
	
	override generarMail(String codigoDeValidacion, String mail) {
		new Mail("Tu Codigo De Validacion", "Tu codigo De Validacion Es"+codigoDeValidacion,
			mail, "AterrizarAdmin@gmail.com")
	}
	
}