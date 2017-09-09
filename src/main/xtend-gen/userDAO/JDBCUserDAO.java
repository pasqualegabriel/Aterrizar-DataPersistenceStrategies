package userDAO;

import com.google.common.base.Objects;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.function.Consumer;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Pure;
import service.User;
import userDAO.UserDAO;

@Accessors
@SuppressWarnings("all")
public class JDBCUserDAO implements UserDAO {
  @Accessors
  public static abstract class Evaluator<T extends Object> {
    public T value;
    
    public Evaluator(final T value) {
      this.value = value;
    }
    
    public abstract void evaluate(final PreparedStatement ps, final int index);
    
    @Pure
    public T getValue() {
      return this.value;
    }
    
    public void setValue(final T value) {
      this.value = value;
    }
  }
  
  public static class StringEvaluator extends JDBCUserDAO.Evaluator<String> {
    public StringEvaluator(final String value) {
      super(value);
    }
    
    @Override
    public void evaluate(final PreparedStatement ps, final int index) {
      try {
        ps.setString(index, this.value);
      } catch (Throwable _e) {
        throw Exceptions.sneakyThrow(_e);
      }
    }
  }
  
  public static class BooleanEvaluator extends JDBCUserDAO.Evaluator<Boolean> {
    public BooleanEvaluator(final Boolean value) {
      super(value);
    }
    
    @Override
    public void evaluate(final PreparedStatement ps, final int index) {
      try {
        ps.setBoolean(index, (this.value).booleanValue());
      } catch (Throwable _e) {
        throw Exceptions.sneakyThrow(_e);
      }
    }
  }
  
  public static class DateEvaluator extends JDBCUserDAO.Evaluator<Date> {
    public DateEvaluator(final Date value) {
      super(value);
    }
    
    @Override
    public void evaluate(final PreparedStatement ps, final int index) {
      try {
        long _time = this.value.getTime();
        ps.setLong(index, _time);
      } catch (Throwable _e) {
        throw Exceptions.sneakyThrow(_e);
      }
    }
  }
  
  public JDBCUserDAO() {
    try {
      Class.forName("com.mysql.jdbc.Driver");
    } catch (final Throwable _t) {
      if (_t instanceof ClassNotFoundException) {
        final ClassNotFoundException e = (ClassNotFoundException)_t;
        throw new RuntimeException("No se puede encontrar la clase del driver", e);
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
  
  @Override
  public void save(final User aUser) {
    final Function1<Connection, Object> _function = (Connection conn) -> {
      try {
        Object _xblockexpression = null;
        {
          PreparedStatement ps = conn.prepareStatement("INSERT INTO user (firstName, lastName, userName, pasword, mail, birthDate,validateCode, validate) VALUES (?,?,?,?,?,?,?,?)");
          String _name = aUser.getName();
          ps.setString(1, _name);
          String _lastName = aUser.getLastName();
          ps.setString(2, _lastName);
          String _userName = aUser.getUserName();
          ps.setString(3, _userName);
          String _userPassword = aUser.getUserPassword();
          ps.setString(4, _userPassword);
          String _mail = aUser.getMail();
          ps.setString(5, _mail);
          Date _birthDate = aUser.getBirthDate();
          long _time = _birthDate.getTime();
          ps.setLong(6, _time);
          String _validateCode = aUser.getValidateCode();
          ps.setString(7, _validateCode);
          boolean _isValidate = aUser.isValidate();
          ps.setBoolean(8, _isValidate);
          ps.execute();
          int _updateCount = ps.getUpdateCount();
          boolean _notEquals = (_updateCount != 1);
          if (_notEquals) {
            throw new RuntimeException(("No se inserto el Usuario " + aUser));
          }
          ps.close();
          _xblockexpression = null;
        }
        return _xblockexpression;
      } catch (Throwable _e) {
        throw Exceptions.sneakyThrow(_e);
      }
    };
    this.<Object>executeWithConnection(_function);
  }
  
  @Override
  public void update(final User aUser) {
    final Function1<Connection, Object> _function = (Connection conn) -> {
      try {
        Object _xblockexpression = null;
        {
          PreparedStatement ps = conn.prepareStatement("UPDATE user SET firstName = ?, lastName = ?, userName = ?, pasword = ?, mail = ?, birthDate = ?, validateCode = ?, validate = ? WHERE userName = ?");
          String _name = aUser.getName();
          ps.setString(1, _name);
          String _lastName = aUser.getLastName();
          ps.setString(2, _lastName);
          String _userName = aUser.getUserName();
          ps.setString(3, _userName);
          String _userPassword = aUser.getUserPassword();
          ps.setString(4, _userPassword);
          String _mail = aUser.getMail();
          ps.setString(5, _mail);
          Date _birthDate = aUser.getBirthDate();
          long _time = _birthDate.getTime();
          ps.setLong(6, _time);
          String _validateCode = aUser.getValidateCode();
          ps.setString(7, _validateCode);
          boolean _isValidate = aUser.isValidate();
          ps.setBoolean(8, _isValidate);
          String _userName_1 = aUser.getUserName();
          ps.setString(9, _userName_1);
          ps.execute();
          ps.close();
          _xblockexpression = null;
        }
        return _xblockexpression;
      } catch (Throwable _e) {
        throw Exceptions.sneakyThrow(_e);
      }
    };
    this.<Object>executeWithConnection(_function);
  }
  
  @Override
  public User load(final User oneUser) {
    final Function1<Connection, User> _function = (Connection conn) -> {
      try {
        User _xblockexpression = null;
        {
          String _name = oneUser.getName();
          JDBCUserDAO.StringEvaluator _stringEvaluator = new JDBCUserDAO.StringEvaluator(_name);
          Pair<String, JDBCUserDAO.StringEvaluator> _mappedTo = Pair.<String, JDBCUserDAO.StringEvaluator>of("firstName", _stringEvaluator);
          String _lastName = oneUser.getLastName();
          JDBCUserDAO.StringEvaluator _stringEvaluator_1 = new JDBCUserDAO.StringEvaluator(_lastName);
          Pair<String, JDBCUserDAO.StringEvaluator> _mappedTo_1 = Pair.<String, JDBCUserDAO.StringEvaluator>of("lastName", _stringEvaluator_1);
          String _userName = oneUser.getUserName();
          JDBCUserDAO.StringEvaluator _stringEvaluator_2 = new JDBCUserDAO.StringEvaluator(_userName);
          Pair<String, JDBCUserDAO.StringEvaluator> _mappedTo_2 = Pair.<String, JDBCUserDAO.StringEvaluator>of("userName", _stringEvaluator_2);
          String _userPassword = oneUser.getUserPassword();
          JDBCUserDAO.StringEvaluator _stringEvaluator_3 = new JDBCUserDAO.StringEvaluator(_userPassword);
          Pair<String, JDBCUserDAO.StringEvaluator> _mappedTo_3 = Pair.<String, JDBCUserDAO.StringEvaluator>of("pasword", _stringEvaluator_3);
          String _mail = oneUser.getMail();
          JDBCUserDAO.StringEvaluator _stringEvaluator_4 = new JDBCUserDAO.StringEvaluator(_mail);
          Pair<String, JDBCUserDAO.StringEvaluator> _mappedTo_4 = Pair.<String, JDBCUserDAO.StringEvaluator>of("mail", _stringEvaluator_4);
          Date _birthDate = oneUser.getBirthDate();
          JDBCUserDAO.DateEvaluator _dateEvaluator = new JDBCUserDAO.DateEvaluator(_birthDate);
          Pair<String, JDBCUserDAO.DateEvaluator> _mappedTo_5 = Pair.<String, JDBCUserDAO.DateEvaluator>of("birthDate", _dateEvaluator);
          String _validateCode = oneUser.getValidateCode();
          JDBCUserDAO.StringEvaluator _stringEvaluator_5 = new JDBCUserDAO.StringEvaluator(_validateCode);
          Pair<String, JDBCUserDAO.StringEvaluator> _mappedTo_6 = Pair.<String, JDBCUserDAO.StringEvaluator>of("validateCode", _stringEvaluator_5);
          boolean _isValidate = oneUser.isValidate();
          JDBCUserDAO.BooleanEvaluator _booleanEvaluator = new JDBCUserDAO.BooleanEvaluator(Boolean.valueOf(_isValidate));
          Pair<String, JDBCUserDAO.BooleanEvaluator> _mappedTo_7 = Pair.<String, JDBCUserDAO.BooleanEvaluator>of("validate", _booleanEvaluator);
          ArrayList<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>> _newArrayList = CollectionLiterals.<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>>newArrayList(_mappedTo, _mappedTo_1, _mappedTo_2, _mappedTo_3, _mappedTo_4, _mappedTo_5, _mappedTo_6, _mappedTo_7);
          final Function1<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>, Boolean> _function_1 = (Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>> pair) -> {
            JDBCUserDAO.Evaluator<? extends Object> _value = pair.getValue();
            return Boolean.valueOf((!Objects.equal(_value.value, null)));
          };
          Iterable<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>> filters = IterableExtensions.<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>>filter(_newArrayList, _function_1);
          final StringBuilder filterCondition = new StringBuilder();
          final Consumer<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>> _function_2 = (Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>> pair) -> {
            final String column = pair.getKey();
            String _string = filterCondition.toString();
            boolean _equals = _string.equals("");
            boolean _not = (!_equals);
            if (_not) {
              filterCondition.append("and ");
            }
            filterCondition.append((column + " = ? "));
          };
          filters.forEach(_function_2);
          String _string = filterCondition.toString();
          String _plus = ("SELECT * FROM user WHERE " + _string);
          PreparedStatement ps = conn.prepareStatement(_plus);
          for (int i = 0; (i < IterableExtensions.size(filters)); i++) {
            final Iterable<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>> _converted_filters = (Iterable<Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>>)filters;
            Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>> _get = ((Pair<String, ? extends JDBCUserDAO.Evaluator<? extends Object>>[])Conversions.unwrapArray(_converted_filters, Pair.class))[i];
            JDBCUserDAO.Evaluator<? extends Object> _value = _get.getValue();
            _value.evaluate(ps, (i + 1));
          }
          ResultSet resultSet = ps.executeQuery();
          User aUser = null;
          boolean _next = resultSet.next();
          if (_next) {
            boolean _notEquals = (!Objects.equal(aUser, null));
            if (_notEquals) {
              throw new RuntimeException("Existe mas de un user");
            }
            User _user = new User();
            aUser = _user;
            String _string_1 = resultSet.getString("firstName");
            aUser.setName(_string_1);
            String _string_2 = resultSet.getString("lastName");
            aUser.setLastName(_string_2);
            String _string_3 = resultSet.getString("userName");
            aUser.setUserName(_string_3);
            String _string_4 = resultSet.getString("pasword");
            aUser.setUserPassword(_string_4);
            String _string_5 = resultSet.getString("mail");
            aUser.setMail(_string_5);
            long _long = resultSet.getLong("birthDate");
            Date _date = new Date(_long);
            aUser.setBirthDate(_date);
            String _string_6 = resultSet.getString("validateCode");
            aUser.setValidateCode(_string_6);
            boolean _boolean = resultSet.getBoolean("validate");
            aUser.setValidate(_boolean);
          }
          ps.close();
          _xblockexpression = aUser;
        }
        return _xblockexpression;
      } catch (Throwable _e) {
        throw Exceptions.sneakyThrow(_e);
      }
    };
    return this.<User>executeWithConnection(_function);
  }
  
  /**
   * Ejecuta un bloque de codigo contra una conexion.
   */
  public <T extends Object> T executeWithConnection(final Function1<Connection, T> bloque) {
    Connection connection = this.openConnection("jdbc:mysql://localhost:8889/epers-1?user=root&password=root");
    try {
      return bloque.apply(connection);
    } catch (final Throwable _t) {
      if (_t instanceof SQLException) {
        final SQLException e = (SQLException)_t;
        throw new RuntimeException("Error no esperado", e);
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    } finally {
      this.closeConnection(connection);
    }
  }
  
  /**
   * Establece una conexion a la url especificada
   * @param url - la url de conexion a la base de datos
   * @return la conexion establecida
   */
  public Connection openConnection(final String url) {
    try {
      return DriverManager.getConnection("jdbc:mysql://localhost:3306/a_cara_de_perro_aterrizar?user=root&password=bocajuniors");
    } catch (final Throwable _t) {
      if (_t instanceof SQLException) {
        final SQLException e = (SQLException)_t;
        throw new RuntimeException("No se puede establecer una conexion", e);
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
  
  /**
   * Cierra una conexion con la base de datos (libera los recursos utilizados por la misma)
   * @param connection - la conexion a cerrar.
   */
  public void closeConnection(final Connection connection) {
    try {
      connection.close();
    } catch (final Throwable _t) {
      if (_t instanceof SQLException) {
        final SQLException e = (SQLException)_t;
        throw new RuntimeException("Error al cerrar la conexion", e);
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
  
  @Override
  public void clearAll() {
    final Function1<Connection, Object> _function = (Connection conn) -> {
      try {
        Object _xblockexpression = null;
        {
          PreparedStatement ps = conn.prepareStatement("DElETE FROM user");
          ps.execute();
          ps.close();
          _xblockexpression = null;
        }
        return _xblockexpression;
      } catch (Throwable _e) {
        throw Exceptions.sneakyThrow(_e);
      }
    };
    this.<Object>executeWithConnection(_function);
  }
}
