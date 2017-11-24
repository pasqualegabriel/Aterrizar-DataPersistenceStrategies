package perfiles

import org.eclipse.xtend.lib.annotations.Accessors

//Responsabilidad: Composite de las reglas que permiten el acceso

@Accessors
abstract class AccessPermited extends AccessOfPrivacy{
	
	// esta es la abstracta
	//ruleofsucces Componedor
	//los otros , pirvate acces, public acces, onlyfriends es el leaf.
	//el private handler inicia al componedor con las 3 leafs, y despues es todo igual.
	
	// hay que revisar los commands y rehacerlos prolijos
	// hay que cambiar los nombres que quedaron flojos y sacar las cosas comentadas
	// hay que hacer bien los filtros.
	
	abstract override canHandle(Visibilidad visibilidad, String author, String anUserName) 
	
	
	
}