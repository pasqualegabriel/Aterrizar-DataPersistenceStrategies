package service;

import service.User;

@SuppressWarnings("all")
public interface UserService {
  public abstract User singUp(final String name, final String lastName, final String userName, final String mail, final String birthDate);
  
  public abstract boolean validate(final String code);
  
  public abstract User signIn(final String username, final String password);
  
  public abstract void changePassword(final String username, final String oldPassword, final String newPassword);
}
