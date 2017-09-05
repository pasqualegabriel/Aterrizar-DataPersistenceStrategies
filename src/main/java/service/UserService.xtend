package service

interface UserService {
	
	def User singUp(String name, String lastName, String userName, String mail, String  birthDate)
	def boolean validate(String code)
	def User signIn(String username, String password)
	def void changePassword(String username, String oldPassword, String newPassword)
	
	
	
}