package leaderboardService

import runner.Runner
import daoImplementacion.HibernateUserDAO

class ServicioDeRaking implements LeaderboardService {
	
	HibernateUserDAO userDAO
	
	new (HibernateUserDAO aUserDAO){	
		userDAO = aUserDAO
	}
	
	override rankingDestinos() {
		
		Runner.runInSession[ 
			
			userDAO.getRankedDestinos
			
			
		]
	}
	
	override rankingCompradores() {
		
		Runner.runInSession[
			userDAO.getRankedCompradores
		]
	}
	
	override rankingPagadores() {
		
		Runner.runInSession[
			userDAO.getRankedPagadores
		]
	}
}
	
