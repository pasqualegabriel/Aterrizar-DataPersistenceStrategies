package service

class RandomNumberGenerator implements CodeGenerator{
	
	override generarCodigo() {
		var aleatoryNumber = (Math.random * 999999999 ) + 1000000000
		var toInt = aleatoryNumber.intValue
		toInt.toString
	}
	
}