package service

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List
import asientoServicio.Reserva
import asientoServicio.Compra

@Accessors
class User {

	String 	name
	String 	lastName
	String 	userName
	String 	userPassword
	String 	mail
	Date 	birthDate
	Boolean validate
	String  validateCode
	Reserva reserva 
	Double monedero
	List<Compra> compras   = newArrayList
	
	
	new(){
		super()
		monedero		  = 0.00
	}
	
	new(String name, String lastName, String userName, String mail, String userPassword, Date birthDate) {
		
		this.name 	      = name
		this.lastName     = lastName
		this.userName     = userName
		this.mail         = mail
		this.userPassword = userPassword
		this.birthDate    = birthDate
		this.validate     = false
		this.validateCode = ""
		monedero		  = 0.00
	}
	
	def validateAccount() {
		validate = true
	}
	
	def isValid() {
		this != null && validate
	}
	
	
	

}
