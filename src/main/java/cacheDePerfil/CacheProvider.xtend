package cacheDePerfil

import redis.clients.jedis.Jedis

class CacheProvider {
	
	private static CacheProvider INSTANCE
    private Jedis jedis

    def synchronized static CacheProvider getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new CacheProvider
        }
        return INSTANCE
    }

    private new() {
        this.jedis = new Jedis("localhost")
    }

    def Jedis getJedis(){
        return jedis
    }
	
}