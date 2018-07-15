package cacheDePerfil

import perfiles.Profile
import java.util.function.Supplier
import java.util.List
import perfiles.Publication

abstract class RedisProfile {
	
	def Boolean canHandle(Boolean existsKey)
	
	def Profile execute(KeyDeCacheDePerfil key, Supplier<List<Publication>> bloque, CacheDePerfil aCacheDePerfil)
	
}