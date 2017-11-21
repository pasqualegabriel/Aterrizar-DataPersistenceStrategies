package perfiles

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.LinkedHashSet
import java.util.Set


@Accessors
abstract class Nota {

	Visibilidad 	visibilidad
	String      	cuerpo
	
	
	
	
	/// Refactorizar para que no sean mas Strings, RatingDeUsuario --> MeGusta  / NoMeGusta.
	Set<String> 	meGustan
	Set<String>     noMeGustan
	
	
	String 			author
	
	new(){				
		this.meGustan	= new LinkedHashSet<String>
		this.noMeGustan	= new LinkedHashSet<String>	
	}

	new (String author , String unCuerpo,Visibilidad unaVisibilidad){
		this()
		this.visibilidad = unaVisibilidad
		this.cuerpo    	 = unCuerpo 
		this.author      = author
	}

	/**  */
	def agregar(Set<String> aSet, String aUserName) {
		 aSet.add(aUserName)
	}
	def quitar(Set<String> aSet, String aUserName) {
		 aSet.remove(aUserName)
	}
	
}
