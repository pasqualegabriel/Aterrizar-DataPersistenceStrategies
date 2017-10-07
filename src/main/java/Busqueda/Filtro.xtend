package Busqueda

import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
abstract class Filtro {
	
	@Id
    @GeneratedValue
	int id
	
	def abstract String getFiltro()
}