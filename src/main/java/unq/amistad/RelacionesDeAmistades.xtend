package unq.amistad

import java.time.LocalDateTime
import daoImplementacion.Neo4jDAO
import runner.Runner
import daoImplementacion.HibernateUserDAO

class RelacionesDeAmistades implements AmigoService {
	
	Neo4jDAO 		  userDAONeo4j
	HibernateUserDAO  userDAOHibernate
	
	new(){
		userDAONeo4j     = new Neo4jDAO
		userDAOHibernate = new HibernateUserDAO
	}
	
	override mandarSolicitud(String emisor, String receptor) {
		userDAONeo4j.mandarSolicitudDeAmistad(emisor,receptor, LocalDateTime.now.toString())
	}
	
	override aceptarSolicitud(String receptor, String emisor) {
		userDAONeo4j.aceptarSolicitudDeAmistad(receptor,emisor)
	}
	
	override verSolicitudes(String usuario) {
		userDAONeo4j.getSolicitudes(usuario);
	}
	
	override amigos(String usuario) {
		Runner.runInSession[
			val idsDeAmigos = userDAONeo4j.getAmistades(usuario)
			val users       = newArrayList
			idsDeAmigos.forEach[ users.add(userDAOHibernate.loadbyname(it)) ]
			users
		]
	
	}
	
	override amigosDespuesDe(String usuario, LocalDateTime fecha) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override enviar(String usuario, String mensaje, String amigo) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override mensajes(String usuario, String amigo) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override conectados(String usuario) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}