## Entrega 4 - Grafos

Aterrizar desea integrar una red social a su sitio web. 
La idea de la red social es que se creen relaciones de amistad entre los usuarios y que ellos se puedan mandar mensajes.

Para ello van a utilizar la base de datos Neo4J.

## Funcionalidad

### Amigos
Los usuarios van a poder agregar a otros usuarios como amigos. Para que dos usuarios sean amigos, 
un usuario tiene que mandarle una solicitud de amistad al otro y este la tiene que aceptar. 
A partir de ese momento, los usuarios son amigos.

### Mensajes
Los amigos se pueden mandar mensajes 'privados' que solo ellos pueden leer.
Los mensajes entre los usuarios son como un chat, cada usuario puede agregar mensajes al chat.
De cada mensaje se debe guardar quien lo envió y la hora de envío del mensaje.

  
## Servicios
Se pide que implementen los siguientes servicios los cuales serán consumidos por el frontend de la aplicación.

#### AmigoService
- `mandarSolicitud(usuario1, usuario2)` El _usuario1_ le manda una solicitud de amistad al _usuario2_
- `aceptarSolicitud(usuario1, usuario2)` El _usuario1_ acepta la solicitud del _usuario2_. A partir de este momento, los usuarios son amigos.
- `verSolicitudes(usuario):List<solicitud>` Devuelve las solicitudes de amistad que tiene el _usuario_.
- `amigos(usuario):List<Usuario>` Devuelve la lista de amigos del _usuario_
- `amigosDespuesDe(usuario, fecha):List<Usuario>` Devuelve la lista de amigos del _usuario_ que conoce desde la _fecha_ en adelante.
- `enviar(usuario, String mensaje, amigo )` El _usuario_ le manda un _mensaje_ al _amigo_. 
- `mensajes(usuario, amigo)` Devolver los mensajes enviados entre el _usuario_ y el _amigo_ 
- `conectados(usuario):List<Usuario>` Devuelve todas las personas con las que el _usuario_ esta conectado. Es decir, devolver los amigos de _usuario_ y los amigos de los amigos recursivamente.
