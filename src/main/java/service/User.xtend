package service

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date

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

	new(){
		super()
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
	}

}
