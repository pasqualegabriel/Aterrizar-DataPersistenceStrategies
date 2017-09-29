package runner

//import org.hibernate.Session
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration

class SessionFactoryProvider {
	
	static SessionFactoryProvider INSTANCE

	SessionFactory sessionFactory
	
	static def getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new SessionFactoryProvider
		}
		INSTANCE
	}
	
	 static def void destroy() {
		if (INSTANCE != null && INSTANCE.sessionFactory != null) {
			INSTANCE.sessionFactory.close
		}
		INSTANCE = null
	}
	
	 private new() {
		var configuration = new Configuration
		configuration.configure("hibernate.cfg.xml")
		this.sessionFactory = configuration.buildSessionFactory
	}
	
	def createSession(){
		sessionFactory.openSession
	}
}