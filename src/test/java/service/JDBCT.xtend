package service

import userDAO.JDBCUserDAO
import org.junit.Test

class JDBCT extends Abs{
	
	override setUserService(){
		userDAO       = new JDBCUserDAO
		serviceTest   = new Service(userDAO, generatorMail, unGeneradorDeCodigo, unMailService)
	}
	
	@Test
	def void run(){
		// Ejecuta todos los test de la clase abstracta
	}		
}