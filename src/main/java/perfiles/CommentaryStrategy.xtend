package perfiles


class CommentaryStrategy extends StrategyOfPublication{
	
	Comentary aComentary
	
	new(Comentary aComentary, ProfileService aProfileService){
		super(aProfileService)
		this.aComentary = aComentary 
	}
	
	override execute() {
		aService.publicitarComentario(aNota,aComentary)
	}
	
	
	
}