package Busqueda
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.ManyToOne

@Accessors
@Entity
class FiltroSimple extends Filtro{
	
	String valor
	
	@ManyToOne
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
	
}