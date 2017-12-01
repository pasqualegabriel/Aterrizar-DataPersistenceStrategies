package cacheDePerfil

import com.google.gson.Gson
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.List

class JsonSerializer {
	
	def static String toJson(Object object){
        return new Gson().toJson(object)
    }
    
    def static <T>  fromJson(String json, Class<T> entityClass){
        return new Gson().fromJson(json, new SingleParameterizedType(entityClass));
    }

    private static class SingleParameterizedType implements ParameterizedType {

        private Type type;

        private new(Type type) {
            this.type = type;
        }

        override Type[] getActualTypeArguments() {
            return #{type};
        }

        override
        public Type getRawType() {
            return type
        }

        override
        public Type getOwnerType() {
            return null
        }

    }
}