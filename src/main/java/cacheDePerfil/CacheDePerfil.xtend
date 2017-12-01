package cacheDePerfil

import perfiles.Profile
import redis.clients.jedis.Jedis


class CacheDePerfil {
	
	private Jedis jedis;
	
	new(){
		this.jedis = CacheProvider.getInstance().getJedis()
	}
	
	def put(KeyDeCacheDePerfil key, Profile profile) {
		 jedis.set(key.generateValue, JsonSerializer.toJson(profile))
	}
	
	def Profile get(KeyDeCacheDePerfil key) {
		var value = this.jedis.get(key.generateValue)
        JsonSerializer.fromJson(value, Profile)
	}
	
	def clear() {
		jedis.flushAll()
	}
	
}