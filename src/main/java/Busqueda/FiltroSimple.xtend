package Busqueda

class FiltroSimple implements Filtro{
	
	String valor
	Campo campo
	
	new(){
		super()
	}
	
	new(Campo unCampo, String unValor){
		campo = unCampo
		valor = unValor
	}
	
	override getFiltro() {
		campo.campo + " == " + valor
	}
	
}