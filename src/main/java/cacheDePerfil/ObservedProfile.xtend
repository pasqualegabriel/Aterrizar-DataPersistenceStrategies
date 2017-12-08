package cacheDePerfil

import java.util.List
import redis.clients.jedis.Jedis
import java.util.function.Supplier
import perfiles.Publication
import perfiles.Profile
//cambiar nombre
class ObservedProfile {
	
	List<RedisProfile> observedProfiles
	
	new(){
		super()
		observedProfiles = #[new RedisDisconnected, new ExistsKeyInRedis, new GetAndSaveProfileRedis]
	}
	
	def Profile canObserverProfile(KeyDeCacheDePerfil key, Supplier<List<Publication>> bloque, Jedis jedis, CacheDePerfil aCacheDePerfil) {
		
		val isConnected = jedis.connected
		val existsKey   = jedis.exists(key.generateValue)

		
		observedProfiles.findFirst[it.canHandle(isConnected, existsKey)].execute(key, bloque, aCacheDePerfil)
	}
	

	
}