package service

import org.junit.Test
import daoImplementacion.HibernateUserDAO

class Hibernate extends Abs{
	
	override setUserService(){
		userDAO       = new HibernateUserDAO
		serviceTest   = new ServiceHibernate(userDAO, generatorMail, unGeneradorDeCodigo, unMailService)
	}
	
	@Test
	def void run(){
		// Ejecuta todos los test de la clase abstracta
	}		
	
}