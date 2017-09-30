package Busqueda

import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
abstract class Filtro {
	
	@Id
	@Column(name="id")
    @GeneratedValue
	int id
	
	def abstract String getFiltro()
}