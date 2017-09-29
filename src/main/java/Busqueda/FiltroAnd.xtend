package Busqueda

class FiltroAnd extends FistroCompuesto {
	
	new(Filtro aFilterOne, Filtro aFilterTwo) {
		super(aFilterOne, aFilterTwo)
	}
	
	override comparator() {
		" and "
	}
	
	override getFiltro() {
		super.filtro
	}
	
	
	
}