package Busqueda

abstract class FistroCompuesto implements Filtro{
	
	Filtro filterOne
	Filtro filterTwo
	
	new(Filtro aFilterOne, Filtro aFilterTwo){
		filterOne = aFilterOne
	    filterTwo = aFilterTwo
	}
	
	def String comparator()
	
	override getFiltro(){
		"(" + filterOne.getFiltro + ")" + comparator + "(" + filterTwo.getFiltro + ")"
	}
	
}