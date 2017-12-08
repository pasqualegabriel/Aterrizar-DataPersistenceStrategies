package cacheDePerfil

import java.util.List
import redis.clients.jedis.Jedis
import java.util.function.Supplier
import perfiles.Publication
import perfiles.Profile

class KeyAccessor {
	
	List<RedisProfile> keyRules
	
	new(){
		super()
		keyRules = #[new ExistsKeyInRedis, new GetAndSaveProfileRedis]
	}
	
	def Profile canObserverProfile(KeyDeCacheDePerfil key, Supplier<List<Publication>> bloque, Jedis jedis, CacheDePerfil aCacheDePerfil) {
		
		val existsKey   = jedis.exists(key.generateValue)
		
		keyRules.findFirst[it.canHandle(existsKey)].execute(key, bloque, aCacheDePerfil)
	}
	

	
}