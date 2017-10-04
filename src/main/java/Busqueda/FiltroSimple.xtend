package Busqueda
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.ManyToOne
import javax.persistence.CascadeType
import javax.persistence.FetchType


@Accessors
@Entity
class FiltroSimple extends Filtro{

	
	public String valor
	

	@ManyToOne(fetch= FetchType.EAGER,cascade=CascadeType.ALL)
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