package dao

import java.io.IOException;
import java.util.List;

import org.bson.types.ObjectId;
import org.jongo.MongoCollection;
import org.jongo.MongoCursor;

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class GenericMongoDAO<T> {

	Class<T> entityType;
	MongoCollection mongoCollection;

	new(Class<T> entityType) {
		this.entityType = entityType;
		this.mongoCollection = this.getCollectionFor(entityType);
	}

	def getCollectionFor(Class<T> entityType) {
		var jongo = MongoConnection.getInstance().getJongo();
		jongo.getCollection(entityType.getSimpleName());
	}

	def void deleteAll() {
		this.mongoCollection.remove();
	}

	def void save(T object) {
		this.mongoCollection.insert(object);
	}

	def void save(List<T> objects) {
		this.mongoCollection.insert(objects.toArray());
	}

	def T load(String id) {
		var objectId = new ObjectId(id);
		mongoCollection.findOne(objectId).^as(entityType)
	}

	def List<T> find(String query, Object... parameters) {
		try {
			var MongoCursor<T> all = mongoCollection.find(query, parameters).^as(this.entityType);

			var List<T> result = this.copyToList(all);
			all.close();

			return result;
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	def void findUpdate(String query, Object... parameters) {
		try {
			var MongoCursor<T> all = mongoCollection.find(query, parameters).^as(this.entityType);

			var List<T> result = this.copyToList(all);
			all.close();

		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * Copia el contenido de un iterable en una lista
	 */
	def <X> List<X> copyToList(Iterable<X> iterable) {
		val List<X> result = newArrayList
		iterable.forEach[x|result.add(x)]
		return result;
	}

}
