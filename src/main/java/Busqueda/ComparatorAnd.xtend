package Busqueda

import javax.persistence.Entity

@Entity
class ComparatorAnd extends Comparator {
	new(){
	}
	
	override getComparator() {
		"and"
	}
	
}