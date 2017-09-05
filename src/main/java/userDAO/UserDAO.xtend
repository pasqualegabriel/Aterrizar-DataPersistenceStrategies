package userDAO

import service.User

interface UserDAO {

	def void save(User user)

	def User load(String userName, String pasword)

	def void update(User userName)
	
	
	// PREGUNTAR
	def User loadForCode(String string)
	
}