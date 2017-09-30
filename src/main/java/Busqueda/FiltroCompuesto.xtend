package Busqueda
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.OneToOne
import javax.persistence.JoinColumn

@Accessors
@Entity
abstract class FiltroCompuesto extends Filtro{
	
	@OneToOne
	@JoinColumn(name="id")
	Filtro filterOne
	
	@OneToOne
	@JoinColumn(name="id")
	Filtro filterTwo
	
	new(){
		super()
	}
	
	new(Filtro aFilterOne, Filtro aFilterTwo){
		filterOne = aFilterOne
	    filterTwo = aFilterTwo
	}
	
	def String comparator()
	
	override getFiltro(){
		"(" + filterOne.getFiltro + ")" + comparator + "(" + filterTwo.getFiltro + ")"
	}
	
}