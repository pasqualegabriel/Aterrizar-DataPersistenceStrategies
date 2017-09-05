package userDAO;

import org.eclipse.xtend.lib.annotations.Accessors;
import service.User;
import userDAO.UserDAO;

@Accessors
@SuppressWarnings("all")
public class JDBCUserDAO implements UserDAO {
  @Override
  public void save(final User userName) {
    throw new UnsupportedOperationException("TODO: auto-generated method stub");
  }
  
  @Override
  public User load(final String userName, final String pasword) {
    throw new UnsupportedOperationException("TODO: auto-generated method stub");
  }
  
  @Override
  public void update(final User userName) {
    throw new UnsupportedOperationException("TODO: auto-generated method stub");
  }
  
  @Override
  public User loadForCode(final String string) {
    throw new UnsupportedOperationException("TODO: auto-generated method stub");
  }
}
