## Entrega 5 - MongoDB

Despúes de implementar la red social dentro de Aterrizar, subieron mucho las ventas y ahora la empresa quiere hacer 
crecer su red.

El siguiente paso es hacer que los usuarios tengan un perfil. Entro de este perfil, el usuario va a poder 
agregar contenido y otros usuarios van a poder interactuar con ellos.

El contenido principal que un usuario puede agregar a su perfil es una publicación sobre los destinos a los que visitó. <br>
La forma de interacturar con estas publicaciones es poner agregarle comentarios, establecer "Me Gusta" o No me gusta"".

Al agregar un destino o al hacer un comentario se tiene que especificar el nivel de visibilidad, que puede ser:
__privado__, __público__, __solo amigos__.

Para que un usuario pueda interactuar con una publicación o un comentario depende del nivel de visibiliad que se tenga.
Para ello hay que seguir la siguiente regla:

- Para la visibilidades __público__ pueden interactuar todos los usuario.
- Para la visibilidades __solo amigos__ solo puede interactuar la el "dueno" de la publicación/comentario y los usuarios amigos del dueño.
- Para la visibilidades __privado__ solo puede interactuar el dueño de la publicación/comentario 
 
## Servicios
Se pide que implementen los siguientes servicios los cuales serán consumidos por el frontend de la aplicación.

#### PerfilService
- `agregarPublicación(usuario, Publicacion publicacion):Publicacion` El _usuario_ agrega a su perfil una nueva publicación. Hay que validar que el usuario
visitó el destino de la publicación y que no tenga una publicación previa de ese destino.
- `agregarComentario(usuario, publicacion, Comentario comentario):Comentario ` El _usuario_ agrega un comentario a la _publicación_. Hay que validar que el usuario tenga "permiso" para interactuar con la publicación.
- `meGusta(usuario1, publicacion)` El _usuario_ le agrega un "Me Gusta" a una publicación. Hay que validar que el _usuario_ tenga "permiso" para interacturar con esa publicación y que no tenga una calificación previa de ese usuario.   
- `noMeGusta(usuario1, publicacion)` El _usuario_ le agrega un "No me Gusta" a una publicación. Hay que validar que el _usuario_ tenga "permiso" para interacturar con esa publicación y que no tenga una calificación previa de ese usuario.
- `meGusta(usuario1, comentario)` El _usuario_ le agrega un "Me Gusta" a un comentario. Hay que validar que el _usuario_ tenga "permiso" para interacturar con ese comentario y que no tenga una calificación previa de ese usuario.  
- `noMeGusta(usuario1, comentario)` El _usuario_ le agrega un "No me Gusta" a una comentario. Hay que validar que el _usuario_ tenga "permiso" para interacturar con ese comentario y que no tenga una calificación previa de ese usuario.
- `verPerfil(usuario1, usuario2):perfil` El _usuario1_ quiere ver el perfil del _usuario2_. Solo puede ver las cosas que tenga "permiso"
