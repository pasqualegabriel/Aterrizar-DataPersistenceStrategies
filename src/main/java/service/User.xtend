package service

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List
import asientoServicio.Reserva
import asientoServicio.Compra
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne
import javax.persistence.JoinColumn
import Busqueda.Busqueda
import javax.persistence.Transient

@Accessors
@Entity
class User {
	
	@Id
	String 	name
	String 	lastName
	String 	userName
	String 	userPassword
	String 	mail

	Date 	birthDate
	Boolean validate
	String  validateCode
	Double  monedero
	
	@OneToMany(mappedBy="comprador", cascade=CascadeType.ALL)
	List<Compra> compras   = newArrayList
	
	@OneToOne
	@JoinColumn(name="reserva_id")
	Reserva reserva 
	
	@Transient
	//@OneToMany(mappedBy="comprador", cascade=CascadeType.ALL)
	List<Busqueda> busquedas

	new(){
		super()
		monedero		  = 0.00
		compras			  = newArrayList
		reserva			  = null
	}
	
	new(String name, String lastName, String userName, String mail, String userPassword, Date birthDate) {
		this()
		this.name 	      = name
		this.lastName     = lastName
		this.userName     = userName
		this.mail         = mail
		this.userPassword = userPassword
		this.birthDate    = birthDate
		this.validate     = false
		this.validateCode = ""

	}
	
	def validateAccount() {
		validate = true
	}
	
	def agregarCompra(Compra unaCompra) {
		compras.add(unaCompra)
		reserva = null
	}
	
	def agregarBusqueda(Busqueda busqueda) {
		busquedas.add(busqueda)
	}


	
	
	

}
