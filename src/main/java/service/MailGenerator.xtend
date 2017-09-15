package service

import mailSender.Mail

interface MailGenerator {
	
	def Mail generarMail(String codigoDeValidacion, String mail)
}