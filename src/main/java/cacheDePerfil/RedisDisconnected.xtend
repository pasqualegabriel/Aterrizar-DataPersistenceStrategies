package cacheDePerfil

import Excepciones.ExeptionRedisDisconnected
import java.util.function.Supplier
import java.util.List
import perfiles.Publication

class RedisDisconnected extends RedisProfile{
	
	override canHandle(boolean isConnected, Boolean existsKey) {
		!isConnected
	}
	
	override execute(KeyDeCacheDePerfil key, Supplier<List<Publication>> bloque, CacheDePerfil aCacheDePerfil) {
		throw new ExeptionRedisDisconnected("Redis disconnected")
	}
	
	
	
}