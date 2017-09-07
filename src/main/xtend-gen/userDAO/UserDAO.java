package userDAO;

import service.User;

@SuppressWarnings("all")
public interface UserDAO {
  public abstract void save(final User user);
  
  public abstract User load(final String username, final String pasword);
  
  public abstract void update(final User username);
  
  public abstract User loadForCode(final String code);
  
  public abstract User loadForUsernameAndMail(final String username, final String string2);
}
