package dao

import service.User

interface UserDAO {

	def void save(User oneUser)

	def User load(User oneUser)

	def void update(User oneUser)
	
	def void clearAll()

}
