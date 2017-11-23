package aereolinea

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.OneToMany
import javax.persistence.Id
import javax.persistence.Entity
import javax.persistence.FetchType

@Accessors
@Entity
class Aereolinea {
		
	@Id
	String nombre
	
	@OneToMany(fetch= FetchType.LAZY, mappedBy="aerolinea")
	List<Vuelo> vuelosOfertados = newArrayList
	
	new(){	
	}
	
	new(String unNombre){
		nombre=unNombre
	}
}