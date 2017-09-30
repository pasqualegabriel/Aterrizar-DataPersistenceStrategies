package Busqueda

class FiltroOr extends FistroCompuesto {
	
	new(Filtro aFilterOne, Filtro aFilterTwo) {
		super(aFilterOne, aFilterTwo)
	}
	
	override comparator() {
		" or "
	}
	
	override getFiltro() {
		super.filtro
	}
	
}