package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import javax.persistence.OneToMany
import javax.persistence.ManyToOne
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Entity
import javax.persistence.CascadeType

@Accessors
@Entity
class Vuelo {
	@Id
	@GeneratedValue
	int id
	
	@OneToMany
	List<Tramo> tramos = newArrayList

	@ManyToOne(cascade=CascadeType.ALL)
	Aereolinea aerolinea
	
	
	new(){
		super()
	}
	
	new(Aereolinea unaAerolinea){
		aerolinea= unaAerolinea
	}
}