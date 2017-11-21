package perfiles

import unq.amistad.AmigoService
import unq.amistad.RelacionesDeAmistades

abstract class AccessOfPrivacy {
	
	AmigoService servicioDeAmistad
	
	new (){
		servicioDeAmistad = new RelacionesDeAmistades
	} 
	
	def void assertRule(StrategyOfNote strategy){
		strategy.execute
	}
	
	def Boolean canHandle(Visibilidad visibilidad, String author, String anUserName)
	
	def Boolean elUsuarioEsElAutorDeLapublicacion(String author, String anUserName){
		author.equals(anUserName) 
	}
	
	def Boolean elUsuarioEsAmigoDelAutor(String author, String anUserName){
		servicioDeAmistad.amigos(author).stream.anyMatch[it.userName.equals(anUserName)]
	}
	
	
}