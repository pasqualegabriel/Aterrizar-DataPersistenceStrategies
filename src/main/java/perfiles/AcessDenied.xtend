package perfiles


class AcessDenied extends AccessOfPrivacy {
	
	// Modificar para trabajar con logica de negocio en vez de logica de java.	
	override canHandle(Visibilidad visibilidad, String author, String anUserName) { 
		(visibilidad.equals(Visibilidad.Privado) && !elUsuarioEsElAutorDeLapublicacion(author,anUserName)) ||
		(visibilidad.equals(Visibilidad.SoloAmigos) && !elUsuarioEsAmigoDelAutor(author,anUserName)) && !elUsuarioEsElAutorDeLapublicacion(author,anUserName)
	}
	
	override assertRule (StrategyOfNote strategy) {
		strategy.negateAccess
		}
	
}