package daoImplementacion

import dao.AsientoDAO
import aereolinea.Asiento
import runner.Runner
import org.hibernate.Session
import java.util.List

class HibernateAsientoDAO implements AsientoDAO {
	
	override save(Asiento unAsiento) {
		
		val Session session = Runner.currentSession
		session.save(unAsiento)
	}
	
	override load(Integer unAsiento) {
		
		var session = Runner.currentSession
		session.get(Asiento, unAsiento)
	}
	
	override update(Asiento unAsiento) {
		
		val session = Runner.getCurrentSession
		session.update(unAsiento)
	}
	
	override loadAsientos(List<Integer> asientos) {

		val result = newArrayList 
		asientos.forEach[result.add(load(it))]
		result
	}
	
	
}