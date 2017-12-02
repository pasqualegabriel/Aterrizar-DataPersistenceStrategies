package cacheDePerfil

import perfiles.Profile
import redis.clients.jedis.Jedis
import java.util.function.Supplier
import java.util.List
import perfiles.Publication
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CacheDePerfil {
	
	Jedis jedis
	
	new(){
		this.jedis = CacheProvider.getInstance().getJedis
	}
	
	def put(KeyDeCacheDePerfil key, Profile profile) {
		 jedis.set(key.generateValue, JsonSerializer.toJson(profile),"NX","EX",60)
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
		var Profile profile 
		
		if(jedis.exists(key.generateValue)){
			profile = get(key)
		}
		
		else{
			profile = new Profile
			profile.publications= bloque.get
			put(key,profile)
			profile
		}
		

	}
	
}