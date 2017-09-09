package userDAO;

import service.User;

@SuppressWarnings("all")
public interface UserDAO {
  public abstract void save(final User oneUser);
  
  public abstract User load(final User oneUser);
  
  public abstract void update(final User oneUser);
  
  public abstract void clearAll();
}
