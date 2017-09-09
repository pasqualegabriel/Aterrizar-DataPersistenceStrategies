package service;

import Excepciones.IdenticPasswords;
import Excepciones.IncorrectUsernameOrPassword;
import Excepciones.InvalidValidationCode;
import java.util.Date;
import mailSender.Mail;
import mailSender.Postman;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Pure;
import service.User;
import service.UserService;
import userDAO.UserDAO;

@Accessors
@SuppressWarnings("all")
public class Service implements UserService {
  private UserDAO userDAO;
  
  private Postman mailSender;
  
  public Service(final UserDAO userDao) {
    this.userDAO = userDao;
    Postman _postman = new Postman();
    this.mailSender = _postman;
  }
  
  @Override
  public User singUp(final String name, final String lastName, final String userName, final String mail, final Date birthDate) {
    User _xifexpression = null;
    boolean _existeUsuarioCon = this.existeUsuarioCon(userName, mail);
    if (_existeUsuarioCon) {
      throw new RuntimeException("no se puede registrar el Usuario");
    } else {
      User _xblockexpression = null;
      {
        User usuario = new User(name, lastName, userName, mail, birthDate);
        this.userDAO.save(usuario);
        final User userWithCode = this.userDAO.load(usuario);
        Mail _createValidationMail = this.createValidationMail(userWithCode);
        this.mailSender.send(_createValidationMail);
        _xblockexpression = userWithCode;
      }
      _xifexpression = _xblockexpression;
    }
    return _xifexpression;
  }
  
  public Mail createValidationMail(final User user) {
    Mail _xblockexpression = null;
    {
      String _validateCode = user.getValidateCode();
      final String body = ("este es tu codigo de validacion " + _validateCode);
      String _mail = user.getMail();
      _xblockexpression = new Mail("Validacion de cuenta ", body, _mail, "Chafa1234@GilMail");
    }
    return _xblockexpression;
  }
  
  @Override
  public boolean validate(final String code) {
    boolean _xtrycatchfinallyexpression = false;
    try {
      boolean _xblockexpression = false;
      {
        final User userExample = new User();
        userExample.setValidateCode(code);
        User user = this.userDAO.load(userExample);
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
    User _xtrycatchfinallyexpression = null;
    try {
      User _xblockexpression = null;
      {
        final User userExample = new User();
        userExample.setUserName(username);
        userExample.setUserPassword(password);
        _xblockexpression = this.userDAO.load(userExample);
      }
      _xtrycatchfinallyexpression = _xblockexpression;
    } catch (final Throwable _t) {
      if (_t instanceof RuntimeException) {
        final RuntimeException e = (RuntimeException)_t;
        throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return _xtrycatchfinallyexpression;
  }
  
  @Override
  public void changePassword(final String userName, final String oldPassword, final String newPassword) {
    boolean _equals = oldPassword.equals(newPassword);
    if (_equals) {
      throw new IdenticPasswords("Las contraseñas no tienen que ser las mismas");
    }
    try {
      final User userExample = new User();
      userExample.setUserName(userName);
      userExample.setUserPassword(newPassword);
      User user = this.userDAO.load(userExample);
      user.setUserPassword(newPassword);
      this.userDAO.update(user);
    } catch (final Throwable _t) {
      if (_t instanceof RuntimeException) {
        final RuntimeException e = (RuntimeException)_t;
        throw new IncorrectUsernameOrPassword("El usuario o la contrasenia introducidos no son correctos");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
  
  public boolean existeUsuarioCon(final String userName, final String mail) {
    boolean _xtrycatchfinallyexpression = false;
    try {
      boolean _xblockexpression = false;
      {
        final User userExample = new User();
        userExample.setUserName(userName);
        userExample.setMail(mail);
        this.userDAO.load(userExample);
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
  
  @Pure
  public Postman getMailSender() {
    return this.mailSender;
  }
  
  public void setMailSender(final Postman mailSender) {
    this.mailSender = mailSender;
  }
}
