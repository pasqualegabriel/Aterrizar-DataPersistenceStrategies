package userDAO

import java.sql.Connection
import java.sql.SQLException

@FunctionalInterface
interface ConnectionBlock<T> {
	
	def T executeWith(Connection conn) throws SQLException;
	
}