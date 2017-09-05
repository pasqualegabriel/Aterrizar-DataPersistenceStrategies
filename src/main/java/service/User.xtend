package service

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class User {

	String 	name
	String 	lastName
	String 	userName
	String 	pasword
	String 	mail
	String 	birthDate
	boolean validate

	new(String name, String lastName, String userName, String mail, String birthDate) {
		this.name 	   = name
		this.lastName  = lastName
		this.userName  = userName
		this.mail      = mail
		this.birthDate = birthDate
		this.validate  = false
	}

}
