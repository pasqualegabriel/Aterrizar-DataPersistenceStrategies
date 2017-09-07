package userDAO

import service.User
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class JDBCUserDAO implements UserDAO{
	
	override save(User userName) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override load(String userName, String pasword) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override update(User userName) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override loadForCode(String string) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	
	override loadForUsernameAndMail(String username, String string2){
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	

	
}