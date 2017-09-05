package userDAO;

import service.User;

@SuppressWarnings("all")
public interface UserDAO {
  public abstract void save(final User user);
  
  public abstract User load(final String userName, final String pasword);
  
  public abstract void update(final User userName);
  
  public abstract User loadForCode(final String string);
}
