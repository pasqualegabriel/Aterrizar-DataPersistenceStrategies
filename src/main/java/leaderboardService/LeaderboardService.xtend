package leaderboardService

import aereolinea.Destino
import java.util.List
import service.User

interface LeaderboardService {
	
	def List<Destino> rankingDestinos()
	
	def List<User> rankingCompradores()
	
	def List<User> rankingPagadores()
}