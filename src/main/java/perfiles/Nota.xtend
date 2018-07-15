package perfiles

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.LinkedHashSet
import java.util.Set


@Accessors
abstract class Nota {

	Visibilidad 	visibilidad
	String      	cuerpo

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

	def agregarMeGusta(String aUserName) {
		meGustan.add(aUserName)
	}
	
	def agregarNoMeGusta(String aUserName) {
		noMeGustan.add(aUserName)
	}
	
	def quitarMeGusta(String aUserName) {
		meGustan.remove(aUserName)
	}
	
	def quitarNoMeGusta(String aUserName) {
		noMeGustan.remove(aUserName)
	}
	
	
}



