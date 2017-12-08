package cacheDePerfil

import perfiles.Profile
import redis.clients.jedis.Jedis
import java.util.function.Supplier
import java.util.List
import perfiles.Publication
import org.eclipse.xtend.lib.annotations.Accessors
import Excepciones.ExeptionRedisDisconnected
import redis.clients.jedis.JedisPool
import redis.clients.jedis.exceptions.JedisConnectionException

@Accessors
class CacheDePerfil {
	
	Jedis   jedis
	Integer expirationTime

	new(Integer anExpirationTime) {
		this.jedis           = CacheProvider.getInstance.getJedis
		this.expirationTime  = anExpirationTime
	}
	
	def put(KeyDeCacheDePerfil key, Profile profile) {
		 // Como cada usuario individualmente tiene guardado en el cache los perfiles los cuales esta observando (que para cada usuario va a ser
		 // diferente su version del perfil)
		 // cuando necesitamos invalidar el perfil de el author, necesitamos eliminar todas las verciones distintas que tiene de cada observador.
		
		 // Osea, si yo soy pepita, y dionisia mira mi perfil, en el cache va a guardar el perfil pepita+dionisia.
		 // Ahora si jose mira el perfil, va a guardar su vercion como pepita+jose
		 // Una vez pepita hace una nueva publicacion, hay que invalidar todos los perfiles de pepita en el cache.
		 // para eso, generamos un conjunto para pepita, en el cual se guardan todos los observadores que tienen su vercion del perfil 
		 // de pepita en el cache.
		 // Una vez se quiere invalidar el perfil de pepita, se pide todos sus observadores y se eliminan los perfiles particulares.
		 
		 jedis.sadd(key.author,key.observer)
		 jedis.set(key.generateValue, JsonSerializer.toJson(profile),"NX","EX",expirationTime)
	}
	
	def Profile get(KeyDeCacheDePerfil key) {
		var value = this.jedis.get(key.generateValue)
		var profile = JsonSerializer.fromJson(value, Profile)
		profile as Profile
	}
	
	def clear() {
		jedis.flushAll
	}
	
	def Profile getProfile(KeyDeCacheDePerfil key, Supplier<List<Publication>> bloque) {
		
         
		
//		var observedProfile = new ObservedProfile
//		observedProfile.canObserverProfile(key, bloque, jedis, this)
	
		var profile = new Profile
		
		var pool = new JedisPool()
try {
    	pool.getResource();
    // Is connected
} catch (JedisConnectionException e) {
	throw new ExeptionRedisDisconnected("Redis disconnected")
    // Not connected
}
		
//		if(!jedis.isConnected){
//			throw new ExeptionRedisDisconnected("Redis disconnected")
//		}
		
		if(jedis.exists(key.generateValue)){
			profile = get(key)
			profile
		}
		
		else{
			profile = new Profile
			profile.publications= bloque.get
			put(key,profile)
			profile
		}
	}
	
	def borrarPerfil(String author) {
		
		var keys = jedis.smembers(author);
		
		if(!keys.isEmpty){
			keys.forEach[jedis.del(author+it)]
		}	
	}
	
}