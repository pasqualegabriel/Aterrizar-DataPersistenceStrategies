package service;

import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Pure;
import service.InvalidValidationCode;
import service.User;
import service.UserService;
import userDAO.UserDAO;

@Accessors
@SuppressWarnings("all")
public class Service implements UserService {
  private UserDAO userDAO;
  
  public Service(final UserDAO userDao) {
    this.userDAO = userDao;
  }
  
  @Override
  public User singUp(final String name, final String lastName, final String userName, final String mail, final String birthDate) {
    User _xifexpression = null;
    boolean _existeUsuarioCon = this.existeUsuarioCon(userName, mail);
    if (_existeUsuarioCon) {
      throw new RuntimeException("nddo se puede Registrar el Usuario");
    } else {
      User _xblockexpression = null;
      {
        User usuario = new User(name, lastName, userName, mail, birthDate);
        this.userDAO.save(usuario);
        _xblockexpression = usuario;
      }
      _xifexpression = _xblockexpression;
    }
    return _xifexpression;
  }
  
  @Override
  public boolean validate(final String code) {
    boolean _xtrycatchfinallyexpression = false;
    try {
      boolean _xblockexpression = false;
      {
        User user = this.userDAO.loadForCode(code);
        user.setValidate(true);
        this.userDAO.update(user);
        _xblockexpression = true;
      }
      _xtrycatchfinallyexpression = _xblockexpression;
    } catch (final Throwable _t) {
      if (_t instanceof RuntimeException) {
        final RuntimeException e = (RuntimeException)_t;
        throw new InvalidValidationCode("El codigo no es correcto");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return _xtrycatchfinallyexpression;
  }
  
  @Override
  public User signIn(final String username, final String password) {
    return null;
  }
  
  @Override
  public void changePassword(final String username, final String oldPassword, final String newPassword) {
  }
  
  public boolean existeUsuarioCon(final String userName, final String mail) {
    boolean _xtrycatchfinallyexpression = false;
    try {
      boolean _xblockexpression = false;
      {
        this.userDAO.load(userName, mail);
        _xblockexpression = true;
      }
      _xtrycatchfinallyexpression = _xblockexpression;
    } catch (final Throwable _t) {
      if (_t instanceof RuntimeException) {
        final RuntimeException e = (RuntimeException)_t;
        return false;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return _xtrycatchfinallyexpression;
  }
  
  @Pure
  public UserDAO getUserDAO() {
    return this.userDAO;
  }
  
  public void setUserDAO(final UserDAO userDAO) {
    this.userDAO = userDAO;
  }
}
