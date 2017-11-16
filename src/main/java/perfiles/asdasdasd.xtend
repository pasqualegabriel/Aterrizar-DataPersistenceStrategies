package perfiles

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.LinkedHashSet
import java.util.Set
import org.jongo.marshall.jackson.oid.MongoId
import org.jongo.marshall.jackson.oid.MongoObjectId

@Accessors
abstract class asdasdasd {

	@MongoId
	@MongoObjectId
	String     		id
	
	Visibilidad 	visibilidad
	String      	cuerpo
	Set<String> 	meGustan
	Set<String>     noMeGustan
	String 			userProprietor
	
	new(){				
		this.meGustan		= new LinkedHashSet<String>
		this.noMeGustan		= new LinkedHashSet<String>	
	}

	new (String aUserProprietor , String unCuerpo,Visibilidad unaVisibilidad){
		this()
		
		this.visibilidad 	= unaVisibilidad
		this.cuerpo    		= unCuerpo 
		this.userProprietor = aUserProprietor

	}
	
	def tieneComoVisibilidad(Visibilidad unaVisibilidad) {
		this.visibilidad.equals(unaVisibilidad)
	}
	
	def tieneComoMensaje(String unMensaje) {
		this.cuerpo.equals(unMensaje)
	}
	
	def agregarMeGusta(String aUserName){
		this.meGustan.add(aUserName)
	}
	
	def agregarNoMeGusta(String aUserName){
		this.noMeGustan.add(aUserName);
	}
	
	
	def tieneMeGusta() {
		!meGustan.isEmpty()
	}
	
	
	def tieneNoMeGusta() {
		!noMeGustan.isEmpty()
	}
	
	def leDioMeGusta(String unUserName){
		meGustan.contains(unUserName)
	}
	
	def leDioNoMeGusta(String unUserName){
		noMeGustan.contains(unUserName)
	}
	
}
