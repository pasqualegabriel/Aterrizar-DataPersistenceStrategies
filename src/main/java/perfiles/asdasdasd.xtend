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
	String 			author
	
	new(){				
		this.meGustan		= new LinkedHashSet<String>
		this.noMeGustan		= new LinkedHashSet<String>	
	}

	new (String author , String unCuerpo,Visibilidad unaVisibilidad){
		this()
		
		this.visibilidad 	= unaVisibilidad
		this.cuerpo    		= unCuerpo 
		this.author = author

	}
	
	def tieneComoVisibilidad(Visibilidad unaVisibilidad) {
		this.visibilidad.equals(unaVisibilidad)
	}
	
	def tieneComoMensaje(String unMensaje) {
		this.cuerpo.equals(unMensaje)
	}
	
	
	// logica y codigo repetido, falta abstraccion!
	def agregarMeGusta(String aUserName){
		this.meGustan.add(aUserName)
	}
	// logica y codigo repetido, falta abstraccion!
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
