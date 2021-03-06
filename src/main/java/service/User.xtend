package service

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List
import asientoServicio.Reserva
import asientoServicio.Compra
import javax.persistence.CascadeType
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.OneToMany
import javax.persistence.OneToOne
import javax.persistence.FetchType

@Accessors
@Entity
class User {

	@Id
	public String userName
	String 		  name
	String 		  lastName
	String 		  userPassword
	String 	 	  mail
	Date 		  birthDate
	Boolean		  validate
	String 		  validateCode
	Double 	      monedero
	Double 	      gastoTotal
	
	@OneToMany(fetch= FetchType.LAZY,cascade=CascadeType.ALL)
	List<Compra> compras  = newArrayList
	
	@OneToOne(fetch= FetchType.EAGER,cascade=CascadeType.ALL)
	Reserva reserva 

	
	new(){
		super()
		monedero		  = 0.00
		gastoTotal		  = 0.00
	}
	
	new(String name, String lastName, String userName, String mail, String userPassword, Date birthDate) {
		this()
		this.validate     = false
		this.validateCode = ""
		this.name 	      = name
		this.lastName     = lastName
		this.userName     = userName
		this.mail         = mail
		this.userPassword = userPassword
		this.birthDate    = birthDate
		

	}
	
	def validateAccount() {
		validate = true
	}
	
	def agregarCompra(Compra unaCompra) {
		compras.add(unaCompra)
		reserva = null
	}
	
	def puedeEfectuarLaCompra(Reserva unReserva) {
		monedero >= unReserva.calcularPrecio
	}
	
	def efectuarCompra(Reserva unaReserva) {
		var dineroGastado = unaReserva.calcularPrecio
		monedero   = monedero - dineroGastado
		gastoTotal = gastoTotal + dineroGastado
		unaReserva.comprar
	}
	

	
	
}
