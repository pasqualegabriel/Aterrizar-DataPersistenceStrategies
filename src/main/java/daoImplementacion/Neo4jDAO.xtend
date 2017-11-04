package daoImplementacion


import service.User
import org.neo4j.driver.v1.Driver
import org.neo4j.driver.v1.GraphDatabase
import org.neo4j.driver.v1.AuthTokens
import org.neo4j.driver.v1.Values
import java.time.LocalDateTime
import unq.amistad.Solicitud
import unq.amistad.EstadoDeSolicitud

class Neo4jDAO {

	Driver driver

	new() {
		driver = GraphDatabase.driver("bolt://localhost:7687", AuthTokens.basic("neo4j", "password"));
	}

	def save(User oneUser) {
		
		var session = driver.session
		try {
			var query = "MERGE (u:User {userName: {aUserName}}) "

			session.run(query, Values.parameters("aUserName", oneUser.userName))

		} finally {
			session.close
		}
	}


	def clearAll() {
		
		var session = this.driver.session
		try {
			var query = "MATCH (n) " + "DETACH DELETE n"
			session.run(query)

		} finally {
			session.close
		}
	}
	
	def mandarSolicitudDeAmistad(String emisor, String receptor, String fecha) {
		var session = this.driver.session();

		try {
			var query = "MATCH (emisor:User {userName: {emisorUserName}}) " +
					"MATCH (receptor:User {userName: {receptorUserName}}) " +
					"MERGE (emisor)-[s:SOLICITUDDEAMISTAD]->(receptor)"+
					"SET s.fecha 	= {fechaDeLaSolicitud} "+
					"SET s.estado	= {estadoDeSolicitud} ";
					
			session.run(query, Values.parameters("emisorUserName"		, emisor,
												 "receptorUserName"		, receptor,
												 "fechaDeLaSolicitud"	, fecha,
												 "estadoDeSolicitud" 	, EstadoDeSolicitud.Pendiente.name
												 )
						);

		} finally {
			session.close();
		}
	}
	
	def getSolicitudes(String aUserName) {
		var session = this.driver.session();
	
		try {
			var query = 
					"MATCH (receptorUser:User {userName: {userNameid}}) " +
					"MATCH (emisorUser)-[s:SOLICITUDDEAMISTAD]->(receptorUser) " +
					"WHERE s.estado = {estadoDeSolicitud} " +
					"RETURN s, emisorUser";
					
			var result = session.run(query, Values.parameters("userNameid", aUserName,
															  "estadoDeSolicitud",EstadoDeSolicitud.Pendiente.name
															 )
											
									);
			
			return result.list[record |
				var solicitud = record.get(0)
				var usuario = record.get(1)
				
				var fecha = solicitud.get("fecha").asString()
				var emisorUserName = usuario.get("userName").asString()
				var estado		   =  EstadoDeSolicitud.valueOf(solicitud.get("estado").asString()) 	
				return new Solicitud(fecha,emisorUserName,aUserName,estado);
			];
			
			
		} finally {
			session.close();
		}
	}
	
	def aceptarSolicitudDeAmistad(String aUserName, String unEmisor) {
		var session = this.driver.session();
		try {
			var query = 
					"MATCH (receptorUser:User {userName: {aReceptorid}}) 		" 	+
					"MATCH (emisorUser:User {userName:{aEmisorId}}) 			" 	+
					"MATCH (emisorUser)-[s:SOLICITUDDEAMISTAD]->(receptorUser)  " 	+
					"SET    s.estado 	= {estadoDeSolicitud} 					"  	+
					"MERGE (emisorUser)-[a:ESAMIGO]->(receptorUser) 		    "   +
					"SET    a.fecha 	= {fechaAmistad}					    "	+
					"MERGE (receptorUser)-[b:ESAMIGO]->(emisorUser)				"	+
					"SET    b.fecha 	= {fechaAmistad}                        "

		
			session.run(query, Values.parameters			("aReceptorid", aUserName,
															  "aEmisorId",unEmisor,
															  "estadoDeSolicitud",EstadoDeSolicitud.Aceptado.name,
															  "fechaAmistad", LocalDateTime.now.toString()
															 )
											
									);
			

					
		} finally {
			session.close();
		}
		
	}
	
	
	def getAmistades(String aUserName) {
		
		var session = this.driver.session
	
		try {
			var query = 
					"MATCH (emisorUser:User {userName: {userNameid}})	 " +
					"MATCH (emisorUser)-[s:ESAMIGO]->(receptorUser)  	 " +
					"RETURN s								        	 "
					
			var result = session.run(query, Values.parameters("userNameid", aUserName))
			
		    return result.list[record |
				var usuario = record.get(0)
				var userName = usuario.get("userName").asString() 	
				return userName
			]
			
			
		} finally {
			session.close
		}
	}


}
