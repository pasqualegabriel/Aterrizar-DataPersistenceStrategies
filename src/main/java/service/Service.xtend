package service

import org.eclipse.xtend.lib.annotations.Accessors
import userDAO.UserDAO

@Accessors
class Service implements UserService {

	UserDAO userDAO

	new(UserDAO userDao) {
		userDAO = userDao
	}

	override singUp(String name, String lastName, String userName, String mail, String birthDate) {
		
		if(this.existeUsuarioCon(userName,mail)) {throw new RuntimeException("nddo se puede Registrar el Usuario")} 
		else {
			var usuario = new User(name,lastName,userName,mail,birthDate)
			userDAO.save(usuario)
			usuario
		}
		
	}

	override validate(String code) {
		
		try {
			var user = userDAO.loadForCode(code)
			user.validate=true
			userDAO.update(user)
			true
		} catch (RuntimeException e) {throw new InvalidValidationCode("El codigo no es correcto")}
		
		
	}

	override signIn(String username, String password) {
		
	}

	override changePassword(String username, String oldPassword, String newPassword) {
		
	}

	def existeUsuarioCon(String userName, String mail) {

		try {
			// Intenta retornar el usuario sino hace el catch
			userDAO.load(userName, mail)
			true
			
		} catch (RuntimeException  e) {
			// Sino crea la execpcion y retorna false
			return false
		}
		
	}


}
