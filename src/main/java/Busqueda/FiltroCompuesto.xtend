package Busqueda
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.OneToOne
import javax.persistence.CascadeType
import javax.persistence.FetchType

@Accessors
@Entity
class FiltroCompuesto extends Filtro {
	
	@OneToOne(fetch= FetchType.EAGER,cascade=CascadeType.ALL)
	Filtro filterOne
	
	@OneToOne(fetch= FetchType.EAGER,cascade=CascadeType.ALL)
	Filtro filterTwo

	Comparator comparator
	
	new(){
		super()
	}
	
	new(Filtro aFilterOne, Filtro aFilterTwo,Comparator aComparator){
		filterOne  = aFilterOne
	    filterTwo  = aFilterTwo
	    comparator = aComparator
	}
	
	override getFiltro(){
		"(" + filterOne.getFiltro + ") " + comparator.name + " (" + filterTwo.getFiltro + ")"
	}
	
}