## Entrega 2 - Hibernate

¡Felicitaciones!  La prueba de concepto ha sido exitosa.  Se ha aprobado el presupuesto para desarrollar el sistema de vuelos de Aterrizar.com y es hora de empezar a implementar funcionalidad.

## Funcionalidad

### Aerolíneas y Vuelos
Aterrizar vende vuelos de varias aerolíneas. De cada aerolínea se sabe el nombre y un conjunto de vuelos ofertados.
Cada vuelo está conformado por un conjunto de tramos, si es directo  tiene un solo tramo y si es con escala, tiene varios.

Cada tramo tiene un origen y un destino, hora de llegada y de salida, un precio base y los asientos disponibles.

De los asientos se sabe que tienen un número que los identifica en un tramo, una categoría, que puede ser: Primera, Business, Turista.

Cada categoría tiene un factor de precio, que  junto con el precio del tramo,  calcula el costo que tiene un asiento.



### Compras y Reservas
Los usuarios pueden reservar asientos que estén libres en un determinado tramo. Estas reservas son válidas por 5 minutos, pasado ese tiempo, se expiran.
Si al realizar una nueva reserva, el usuario ya tenia una reserva válida previamente, ésta se invalida automáticamente, es decir, el usuario solo podrá tener una sola reserva válida a la vez.
Para poder realizar la reserva, el usuario tienen que tener dinero suficiente en su billetera. 

Las reservas activas se pueden confirmar pagando el precio de la misma. El precio se calcula sumando el precio de los asientos 
que contenga esa reserva.
Para poder pagar la reserva, el usuario debe contar con el dinero suficiente en su billetera y la reserva debe ser válida.
 
Una vez que el usuario paga la reserva, se genera una compra y es ese momento el usuario es el dueño de los asientos en los tramos determinados.
 
 
### Busquedas
 
 Los usuarios pueden realizar busquedas de asientos disponibles aplicando varios filtros disponibles:
 
 Los filtros disponibles son:
 - *Por Aerolínea*
 - *Por categoría de asiento*
 - *Por fecha de salida*
 - *Por fecha de llegada*
 - *Por Origen y Destino*
 
 Los filtros pueden combinarse con operadores AND y OR.

Además de los filtrar los resultados, los usuarios pueden ordenar por distintos criterios:
- *Por costo*
- *Por escalas*
- *Por duración*

El orden puede ser Ascendente o Descendente 


## Servicios
Se pide que implementen los siguientes servicios los cuales serán consumidos por el frontend de la aplicación.

#### AsientoService
- `reservar(asiento, usuario):Reserva` el usuario reserva un asiento

- `reservar(asientos, usuario):Reserva` el usuario reserva todos los asientos, reserva todos o ninguno.

- `comprar(reserva, usuario):Compra` el usuario compra la reserva, abonando el precio determinado.

- `compras(usuario):List<Compra>` retorna las compras del usuario

- `disponibles(tramo, usuario):List<Asiento>` el usuario consulta los asientos disponibles para un determinado tramo. Un asiento está disponible
cuando no tiene ninguna reserva activa y cuando no tiene ninguna compra.

#### BusquedaService
- `buscar(Busqueda busqueda, usuario):List<Asiento>` el usuario realiza una busqueda de asientos disponibles con posibles criterios de orden y filtrado.  

- `list(usuario):List<Busqueda>` devuelve las últimas 10 busquedas realizadas por el usuario. Guardar una busqueda implica guardar los criterios de filtro y orden y no los resultados.

- `buscar(busqueda, usuario):List<Asiento>` ejecuta una busqueda guardada previamente por el usuario 

#### LeaderboardService
- `rankingDestinos():List<Destino>` retorna los diez destinos mas vendidos.
- `rankingCompradores():List<Usuario>` retorna los diez usuarios que mas vuelos compraron.
- `rankingPagadores():List<Usuario>` retorna los diez usuarios que mas gastaron comprando asientos. 


## Se pide:
- Que provean implementaciones para las interfaces descriptas anteriormente.
- Que modifiquen el mecanismo de persistencia del `Usuario` de forma de que todo el modelo persistente utilice Hibernate.
- Asignen propiamente las responsabilidades a todos los objetos intervinientes, discriminando entre servicios, DAOs y objetos de negocio.
- Creen test unitarios para cada unidad de código entregada que prueben todas las funcionalidades pedidas, con casos favorables y desfavorables.

### Consejos utiles:
- Enfoquense primero en el modelo y la capa de servicios, traten de asignar responsabilidades a sus objetos para resolver los casos de uso propuestos.
- Pueden comenzar trabajando con implementaciones mock de su capa de DAOs. No es necesario que utilicen algun framework de mocking, pueden simplemente codifcar DAOs que persistan los objetos en mapas y los recuperen desde ahi.
- Una vez que tengan el modelo terminado y validado persistanlo utilizando hibernate, en este punto deberan analizar:

   - Qué objetos deben ser persitentes y cuales no?
   - Cuáles son las claves primarias de cada entidad? Existe algún atributo de negocio que oficie de clave primaria o deberán introducir algún id?
   - Cuál es la cardinalidad de cada una de las relaciones? Como mapearlas?