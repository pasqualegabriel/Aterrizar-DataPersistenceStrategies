package aereolinea

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import javax.persistence.OneToMany
import javax.persistence.ManyToOne
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Entity
import javax.persistence.CascadeType
import javax.persistence.FetchType

@Accessors
@Entity
class Vuelo {
	@Id
	@GeneratedValue
	int id
	
	@OneToMany(fetch= FetchType.LAZY)
	List<Tramo> tramos = newArrayList

	@ManyToOne(fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	Aereolinea aerolinea
	
	
	new(){
		super()
	}
	
	new(Aereolinea unaAerolinea){
		aerolinea= unaAerolinea
	}
}