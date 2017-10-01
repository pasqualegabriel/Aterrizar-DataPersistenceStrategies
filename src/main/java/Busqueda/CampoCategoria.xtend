package Busqueda

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Column
import javax.persistence.GeneratedValue

@Accessors
@Entity
class CampoCategoria extends Campo{
	@Id
	@Column(name="id")
    @GeneratedValue
	int id
	new(){
		super()
	}
	
	override getCampo() {
		"a.categoria.nombre"
	}
}