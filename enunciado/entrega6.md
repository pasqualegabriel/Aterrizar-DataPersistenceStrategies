## Entrega 6 - Redis

Los ingenieros de Aterrizar.com empezaron a ver problemas con los servidores porque la red social estaba creciendo mas de lo que ellos habían planificado.  El problema principal proviene de la previsualización de los perfiles de los usuarios. Aparentemente es un feature que es muy costoso (a nivel de recursos como: tiempo, memoria, cpu, etc).
 
 Nuestro trabajo en esta etapa tiene que solucionar el problema con el calculo del perfil de un usuario. Para ello van a tener que agregar una capa de caché para mejorar la performance del servicio.
Hay que tener en cuenta que hay ciertas  operaciones que modifican el perfil y hay que invalidar la caché. 

## Requerimientos

- `Guardar el perfil de un usuario en la cache:`  Modificar el método __verPerfil__ del __PerfilService__  para que busque el perfil primero en la caché y si no está, traer el perfil de mongo y guardarla en la caché. La caché tiene que ser válida por un minuto, después de ese tiempo, expira. *Pensar bien como armar la key de un perfil*

- `Invalidar caché ` Las operaciones: __agregarPublicación__ y __agregarComentario__ invalidan la caché (si el perfil está en caché), para que re-calculen en la próxima consulta. *Las operaciones __meGusta__ y __noMeGusta__ no invalidan la caché*.