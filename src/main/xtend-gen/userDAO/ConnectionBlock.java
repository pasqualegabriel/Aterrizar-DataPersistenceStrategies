package userDAO;

import java.sql.Connection;
import java.sql.SQLException;

@FunctionalInterface
@SuppressWarnings("all")
public interface ConnectionBlock<T extends Object> {
  public abstract T executeWith(final Connection conn) throws SQLException;
}
