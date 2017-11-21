package perfiles

import java.util.Set

interface StrategyOfNote {
	def void execute()
	
	def void addAndRemove(Set<String> colleccionAAgregar,Set<String> colleccionAQuitar, String aUserId)
}