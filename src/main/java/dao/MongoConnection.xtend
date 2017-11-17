package dao

import org.jongo.Jongo
import com.mongodb.MongoClient

class MongoConnection {
	
	static MongoConnection instance

	static def synchronized getInstance() {
		if (instance == null) {
			instance = new MongoConnection
		}
		instance
	}

	MongoClient client;
	Jongo jongo;
	
	new() {
		this.client = new MongoClient("localhost", 27017);
		this.jongo = new Jongo(this.client.getDB("epersMongo"));
	}
	
	def Jongo getJongo() {
		return this.jongo;
	}
	
}