package unq.amistad

import java.time.LocalDateTime
import runner.Runner
import daoImplementacion.HibernateUserDAO
import java.time.ZoneId
import daoImplementacion.UserNeo4jDAO

class RelacionesDeAmistades implements AmigoService {
	
	UserNeo4jDAO 		  userDAONeo4j
	HibernateUserDAO  userDAOHibernate
	ZoneId 			  zoneId = ZoneId.systemDefault

	new(){
		userDAONeo4j     = new UserNeo4jDAO
		userDAOHibernate = new HibernateUserDAO
	}
	
	def fechaActual(){
		LocalDateTime.now.atZone(zoneId).toEpochSecond
	}
	
	override mandarSolicitud(String emisor, String receptor) {
		userDAONeo4j.mandarSolicitudDeAmistad(emisor, receptor, fechaActual)
	}
	
	override aceptarSolicitud(String receptor, String emisor) {
		userDAONeo4j.aceptarSolicitudDeAmistad(receptor, emisor, fechaActual)
	}
	
	override verSolicitudes(String usuario) {
		userDAONeo4j.getSolicitudes(usuario)
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
		Runner.runInSession[
			val idsDeAmigos = userDAONeo4j.getAmistadesDespuesDe(usuario,fecha.atZone(zoneId).toEpochSecond)
			val users       = newArrayList
			idsDeAmigos.forEach[ users.add(userDAOHibernate.loadbyname(it)) ]
			users
		]
	}
	
	override enviar(String usuario, Mensaje mensaje, String amigo) {
		userDAONeo4j.enviarMensaje(usuario, mensaje.cuerpo, mensaje.fecha.atZone(zoneId).toEpochSecond, amigo)
	}
	
	override mensajes(String usuario, String amigo) {
		userDAONeo4j.mensajesEntreAmigos(usuario, amigo)
	}
	
	override conectados(String usuario) {
		Runner.runInSession[
			val idsDeAmigos = userDAONeo4j.amigosEnCadena(usuario)
			val users       = newArrayList
			idsDeAmigos.forEach[ users.add(userDAOHibernate.loadbyname(it)) ]
			users
		]
	}
	
}