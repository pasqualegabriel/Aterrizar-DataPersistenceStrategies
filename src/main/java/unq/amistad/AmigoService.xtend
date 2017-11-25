package unq.amistad

import java.util.List
import service.User
import java.time.LocalDateTime

interface AmigoService {
	
	def void mandarSolicitud(String emisor, String receptor);

	def void aceptarSolicitud(String confirmador, String confirmado);

	def List<Solicitud> verSolicitudes(String usuario); 
	
	def List<User> amigos(String usuario);

	def List<User> amigosDespuesDe(String usuario, LocalDateTime fecha);

	def void enviar(String usuario, Mensaje mensaje, String amigo);

	def List<Mensaje> mensajes(String usuario, String amigo);

	def List<User> conectados(String usuario);
	
	def Boolean elUsuarioEsAmigoDe(String usuario, String usuario2)
	
	
}

