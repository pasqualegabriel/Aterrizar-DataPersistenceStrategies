package unq.amistad

import java.util.List
import service.User
import java.time.LocalDateTime

interface AmigoService {
	
	def void mandarSolicitud(String emisor, String receptor);

	def void aceptarSolicitud(String confirmador, String confirmado);

	def List<Solicitud> verSolicitudes(String usuario); // solicitud

	def List<User> amigos(String usuario);

	def List<User> amigosDespuesDe(String usuario, LocalDateTime fecha);

	def void enviar(String usuario, String mensaje, String amigo);

	def List<String> mensajes(String usuario, String amigo);

	def List<User> conectados(String usuario);
}

