package cacheDePerfil

import perfiles.Profile
import java.util.function.Supplier
import java.util.List
import perfiles.Publication

class ExistsKeyInRedis extends RedisProfile{
	
	override canHandle(boolean isConnected, Boolean existsKey) {
		isConnected && existsKey
	}
	
	override execute(KeyDeCacheDePerfil key, Supplier<List<Publication>> bloque, CacheDePerfil aCacheDePerfil) {

		var aProfile = new Profile
		aProfile     = aCacheDePerfil.get(key)
		aProfile
	}
	
}