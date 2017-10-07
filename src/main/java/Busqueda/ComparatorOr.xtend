package Busqueda

import javax.persistence.Entity

@Entity
class ComparatorOr extends Comparator {
	
	new(){	
	}
	
	override getComparator() {
		"or"
	}
	
}