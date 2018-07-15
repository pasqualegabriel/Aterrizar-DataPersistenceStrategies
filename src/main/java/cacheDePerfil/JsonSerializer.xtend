package cacheDePerfil

import com.google.gson.Gson
import java.lang.reflect.Type

class JsonSerializer {

	
	def static String toJson(Object object){
        return new Gson().toJson(object)
    }
    
    def static <T>  fromJson(String json,Type type){
        return new Gson().fromJson(json, type);
    }

}