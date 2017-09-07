package userDAO

import service.User

interface UserDAO {

	def void save(User user)

	def User load(String username, String pasword)

	def void update(User username)
	
	// PREGUNTAR
	def User loadForCode(String code)
	
	def User loadForUsernameAndMail(String username, String string2)
}