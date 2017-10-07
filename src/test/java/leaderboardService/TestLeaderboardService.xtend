package leaderboardService


import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import runner.Runner
import org.junit.After
import service.User
import aereolinea.Asiento
import dao.UserDAO
import java.util.Date
import runner.SessionFactoryProvider
import aereolinea.Destino
import aereolinea.Aereolinea
import aereolinea.Tramo
import aereolinea.Vuelo
import categorias.Categoria
import categorias.Primera
import asientoServicio.AsientoService
import asientoServicio.ReservaCompraDeAsientos
import daoImplementacion.HibernateUserDAO

class TestLeaderboardService {
	
	// Se declaran los objetos que se van a utilizar
	LeaderboardService leaderboardServiceSUT
	
	AsientoService asientoService 
	UserDAO userDAO
	
	Destino destino1
	Destino destino2
	Destino destino3
	Destino destino4
	Destino destino5
	Destino destino6
	Destino destino7
	Destino destino8
	Destino destino9
	Destino destino10
	Destino destino11
	
	Aereolinea aerolinea1
	Aereolinea aerolinea2
	
	Vuelo vuelo1
	Vuelo vuelo2
	
	Tramo tramo1
	Tramo tramo2
	Tramo tramo3
	Tramo tramo4
	Tramo tramo5
	Tramo tramo6
	Tramo tramo7
	Tramo tramo8
	Tramo tramo9
	Tramo tramo10
	Tramo tramo11
		
	Asiento asiento1
	Asiento asiento2
	Asiento asiento3
	Asiento asiento4
	Asiento asiento5
	Asiento asiento6
	Asiento asiento7
	Asiento asiento8
	Asiento asiento9
	Asiento asiento10
	Asiento asiento11
	
	Categoria categoriaPrimera
	
	User user1
	User user2
	User user3
	User user4
	User user5
	User user6
	User user7
	User user8
	User user9
	User user10
	User user11
		
	@Before
	def void setUp(){
		// Se instancian los objetos a utilizar
		leaderboardServiceSUT = new ServicioDeRaking
		userDAO = new HibernateUserDAO
		asientoService = new ReservaCompraDeAsientos(userDAO)
		
		destino1 = new Destino=>[nombre="Pekin"]
		destino2 = new Destino=>[nombre="Brazil"]
		destino3 = new Destino=>[nombre="Shangai"]
		destino4 = new Destino=>[nombre="Argentina"]
		destino5 = new Destino=>[nombre="Chile"]
		destino6 = new Destino=>[nombre="Madagascar"]
		destino7 = new Destino=>[nombre="China"]
		destino8 = new Destino=>[nombre="Japon"]
		destino9 = new Destino=>[nombre="Noruega"]
		destino10 = new Destino=>[nombre="Islandia"]
		destino11 = new Destino=>[nombre="Rusia"]
		
		aerolinea1 = new Aereolinea("Golondrina")=>[ vuelosOfertados.add(vuelo1)]
		aerolinea2 = new Aereolinea("Paloma")=>[ vuelosOfertados.add(vuelo2)]
		
		vuelo1 = new Vuelo(aerolinea1)=>[ tramos.addAll(#[tramo1,tramo2,tramo3,tramo4,tramo5])]
		vuelo2 = new Vuelo(aerolinea2)=>[ tramos.addAll(#[tramo6,tramo7,tramo8,tramo9,tramo10,tramo11])]
		
		tramo1= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino2
							 precio= 1.00
							 vuelo= vuelo1
							 asientos.add(asiento1)
		]
		tramo2= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino3
							 precio= 2.00
							 vuelo= vuelo1
							 asientos.add(asiento2)
		]
		tramo3= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino4
							 precio= 3.00
							 vuelo= vuelo1
							 asientos.add(asiento3)
		]
		tramo4= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino5
							 precio= 4.00
							 vuelo= vuelo1
							 asientos.add(asiento4)
		]
		tramo5= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino6
							 precio= 5.00
							 vuelo= vuelo1
							 asientos.add(asiento5)
		]
		tramo6= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino7
							 precio= 6.00
							 vuelo= vuelo2
							 asientos.add(asiento6)
		]
		tramo7= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino8
							 precio= 7.00
							 vuelo= vuelo2
							 asientos.add(asiento7)
		]
		tramo8= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino9
							 precio= 8.00
							 vuelo= vuelo2
							 asientos.add(asiento8)
		]
		tramo9= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino10
							 precio= 9.00
							 vuelo= vuelo2
							 asientos.add(asiento9)
		]
		tramo10= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino1
							 precio= 10.00
							 vuelo= vuelo2
							 asientos.add(asiento10)
		]
		tramo11= new Tramo=>[ destinoOrigen= destino1
							 destinoLlegada= destino2
							 precio= 11.00
							 vuelo= vuelo2
							 asientos.add(asiento11)
		]
		
		categoriaPrimera = new Primera
		
		asiento1 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo1]
		asiento2 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo2]
		asiento3 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo3]
		asiento4 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo4]
		asiento5 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo5]
		asiento6 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo6]
		asiento7 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo7]
		asiento8 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo8]
		asiento9 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo9]
		asiento10 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo10]
		asiento11 = new Asiento=>[categoria= categoriaPrimera; tramo = tramo11]
		
		user1 = new User("Pepita","LaGolondrinaPepitaLaLoca","Eurofirca","pepitagolondrina@gmail.com", "password", new Date())=>[monedero=100000.00]
		user2 = new User("Odin","Nordico","Valhalla","odin@gmail.com", "password", new Date())=>[monedero=100000.00]
		user3 = new User("Gandalf","ElBlanco","ElMago","gandalf@gmail.com", "password", new Date())=>[monedero=100000.00]
		user4 = new User("Gardel","ConSombrero","ConAltaPeluca","gardel@gmail.com", "password", new Date())=>[monedero=100000.00]
		user5 = new User("Darin","Azul","Actor","darin@gmail.com", "password", new Date())=>[monedero=100000.00]
		user6 = new User("Goku","Zero","Kamehameha","goku@gmail.com", "password", new Date())=>[monedero=100000.00]
		user7 = new User("Cachito","Krillin","Pelao","cachito@gmail.com", "password", new Date())=>[monedero=100000.00]
		user8 = new User("Michael","Jackson","Muerto","michael@gmail.com", "password", new Date())=>[monedero=100000.00]
		user9 = new User("Dragon","Larina","Dragonforce","dragonzote@gmail.com", "password", new Date())=>[monedero=100000.00]
		user10 = new User("Ciclope","drina","Ojo","londrina@gmail.com", "password", new Date())=>[monedero=100000.00]
		user11 = new User("Titan","na","Jayan","rina@gmail.com", "password", new Date())=>[monedero=100000.00]
		
		val coleccionUsuario =#[user1,user2,user3,user4,user5,user6,user7,user8,user9,user10,user11] 
		
		Runner.runInSession[ {
			coleccionUsuario.forEach[userDAO.save(it)]
			null
		}]
	}
	
	@Test
	def void testunLeaderBoardServiceRetornaLos10DestinosMasVendidos(){
		//Hacemos que los usuarios reserven asientos y los compren. 
		//Notese que el destino numero 11 no esta en ningun tramo, el destino 2 esta en multiples.
		asientoService.comprar(asientoService.reservar(asiento1,user1),user1) ; asientoService.comprar(asientoService.reservar(asiento2,user2),user2)
		asientoService.comprar(asientoService.reservar(asiento3,user3),user3) ; asientoService.comprar(asientoService.reservar(asiento4,user4),user4)
		asientoService.comprar(asientoService.reservar(asiento5,user5),user5) ; asientoService.comprar(asientoService.reservar(asiento6,user6),user6)
		asientoService.comprar(asientoService.reservar(asiento7,user7),user7) ; asientoService.comprar(asientoService.reservar(asiento8,user8),user8)
		asientoService.comprar(asientoService.reservar(asiento9,user9),user9) ; asientoService.comprar(asientoService.reservar(asiento10,user10),user10)
		asientoService.comprar(asientoService.reservar(asiento11,user11),user11)
		
		
		//Pedimos el ranking de destinos mas vendidos
		var resultado = leaderboardServiceSUT.rankingDestinos
		
		// Deberian ser 10 los resultados
		assertEquals(resultado.size,10)
		
		// Como el destino numero 11 no esta en ningun tramo, no deberia aparecer en la lista
		assertFalse(resultado.stream.anyMatch[it.nombre.equals(destino11.nombre)])
		
		// El destino que esta al principio deberia ser el 2, ya que es el mas vendido
		assertEquals(resultado.get(0).nombre,destino2.nombre)
		
	}
	
	@Test
	def void testunLeaderBoardServiceRetornaLos10UsuariosQueMasVuelosCompraron(){
		//Hacemos que los usuarios reserven asientos y los compren.
		//Notese que el usuario 1 compro 2 asientos y el 11 no compro ninguno.
		asientoService.comprar(asientoService.reservar(asiento1,user1),user1) ; asientoService.comprar(asientoService.reservar(asiento2,user2),user2)
		asientoService.comprar(asientoService.reservar(asiento3,user3),user3) ; asientoService.comprar(asientoService.reservar(asiento4,user4),user4)
		asientoService.comprar(asientoService.reservar(asiento5,user5),user5) ; asientoService.comprar(asientoService.reservar(asiento6,user6),user6)
		asientoService.comprar(asientoService.reservar(asiento7,user7),user7) ; asientoService.comprar(asientoService.reservar(asiento8,user8),user8)
		asientoService.comprar(asientoService.reservar(asiento9,user9),user9) ; asientoService.comprar(asientoService.reservar(asiento10,user10),user10)
		asientoService.comprar(asientoService.reservar(asiento11,user1),user1)
		
		
		//Pedimos el ranking de destinos mas vendidos
		var resultado = leaderboardServiceSUT.rankingCompradores
		
		// Deberian ser 10 los resultados
		assertEquals(resultado.size,10)

		// Como el Usuario 11 no compro ningun vuelo, no deberia estar en la lista
		assertFalse(resultado.stream.anyMatch[it.name.equals(user11.name)])
	
		// El Usuario que esta al principio deberia ser el 1, ya que es el que mas vuelos compro
		assertEquals(resultado.get(0).name,user1.name)	
		assertEquals(resultado.get(0).lastName,user1.lastName)	
	}
	
	@Test
	def void testunLeaderBoardServiceRetornaLos10UsuariosQueMasGastaronComprandoAsientos(){
		
		//Hacemos que los usuarios reserven asientos y los compren
		//Notese que el usuario 1 es el que reservo el tramo que menos vale
		// y que el usuario 11 es el que reservo el tramo que mas vale
		asientoService.comprar(asientoService.reservar(asiento1,user1),user1) ; asientoService.comprar(asientoService.reservar(asiento2,user2),user2)
		asientoService.comprar(asientoService.reservar(asiento3,user3),user3) ; asientoService.comprar(asientoService.reservar(asiento4,user4),user4)
		asientoService.comprar(asientoService.reservar(asiento5,user5),user5) ; asientoService.comprar(asientoService.reservar(asiento6,user6),user6)
		asientoService.comprar(asientoService.reservar(asiento7,user7),user7) ; asientoService.comprar(asientoService.reservar(asiento8,user8),user8)
		asientoService.comprar(asientoService.reservar(asiento9,user9),user9) ; asientoService.comprar(asientoService.reservar(asiento10,user10),user10)
		asientoService.comprar(asientoService.reservar(asiento11,user11),user11)
		
		
		//Pedimos el ranking de destinos mas vendidos
		var resultado = leaderboardServiceSUT.rankingPagadores
		
		// Deberian ser 10
		assertEquals(resultado.size,10)
		
		// Como el Usuario1 es el que menos pago, nodeberia estar en la lista
		assertFalse(resultado.stream.anyMatch[it.name.equals(user1.name)])
	
		// El Usuario que esta al principio deberia ser el 11, ya que es el que mas pago
		assertEquals(resultado.get(0).name,user11.name)
		
	}
	
	
	@After
	def void tearDown(){
		SessionFactoryProvider.destroy
	}

}