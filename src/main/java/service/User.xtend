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
	String 	validateCode
	boolean validate

	new(){
		super()
	}
	
	new(String name, String lastName, String userName, String mail, Date birthDate) {
		this.name 	   = name
		this.lastName  = lastName
		this.userName  = userName
		this.mail      = mail
		this.birthDate = birthDate
		this.validate  = false
			
	}

}
