package perfiles

class CommentaryStrategy extends StrategyOfPublication{
	
	Comentary aComentary
	
	new(Comentary aComentary, Publication aPublication,  ProfileService aProfileService){
		super(aPublication, aProfileService)
		this.aComentary = aComentary 
	}
	
	override execute() {
		aService.publicitarComentario(aPublication,aComentary)
	}
	
}