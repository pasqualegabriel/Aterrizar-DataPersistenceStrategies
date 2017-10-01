package Busqueda
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.ManyToOne
import javax.persistence.CascadeType
import javax.persistence.Id
import javax.persistence.Column
import javax.persistence.GeneratedValue

@Accessors
@Entity
class FiltroSimple extends Filtro{
	@Id
	@Column(name="id")
    @GeneratedValue
	int id
	String valor
	@ManyToOne(cascade=CascadeType.ALL)
	Campo campo
	
	
	
	new(){
		super()
	}
	
	new(Campo unCampo, String unValor){
		campo = unCampo
		valor = unValor
	}
	
	override getFiltro() {
		campo.campo + " = '" + valor + "'"
	}
	
	def getCampo(){
		campo
	}
	
}