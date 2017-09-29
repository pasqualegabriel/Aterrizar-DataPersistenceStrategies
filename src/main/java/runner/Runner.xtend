package runner

import java.util.function.Supplier;
import org.hibernate.Session
import org.hibernate.Transaction

class Runner {
	
	final static  ThreadLocal<Session> CONTEXTO = new ThreadLocal
	
	def static <T> T runInSession(Supplier<T> bloque) {
		// permite anidar llamadas a Runner sin abrir una nueva
		// Sessino cada vez (usa la que abrio la primera vez)
		if (CONTEXTO.get != null) {
			return bloque.get
		}
		
		var Session session = null
		var Transaction tx = null
		
		try {
			session = SessionFactoryProvider.getInstance.createSession
			tx = session.beginTransaction
			
			CONTEXTO.set(session)
			
			//codigo de negocio
			var T resultado = bloque.get
			
			tx.commit
			return resultado
		} catch (RuntimeException e) {
			//solamente puedo cerrar la transaccion si fue abierta antes,
			//puede haberse roto el metodo ANTES de abrir una transaccion
			if (tx != null && tx.isActive) {
				tx.rollback
			}
			throw e
		} finally {
			if (session != null) {
				CONTEXTO.set(null)
				session.close
			}
		}
	}

	def	static  getCurrentSession() {
		var Session session = CONTEXTO.get
		if (session == null) {
			throw new RuntimeException("No hay ninguna session en el contexto")
		}
		session
	}	
}