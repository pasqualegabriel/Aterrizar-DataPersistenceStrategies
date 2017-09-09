package UserDao;

import com.google.common.base.Objects;
import java.util.Date;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import service.User;
import userDAO.JDBCUserDAO;
import userDAO.UserDAO;

@SuppressWarnings("all")
public class TestUserDao {
  private UserDAO userDAO;
  
  private User userTest;
  
  @Before
  public void setUp() {
    JDBCUserDAO _jDBCUserDAO = new JDBCUserDAO();
    this.userDAO = _jDBCUserDAO;
    Date _date = new Date();
    User _user = new User("Pepita", "LaGolondrina", "euforica", "pepitagolondrina@gmail.com", _date);
    this.userTest = _user;
    this.userTest.setValidateCode("golond");
    this.userTest.setUserPassword("123123");
  }
  
  @Test
  public void test00AlGuardarYLuegoRecuperarSeObtieneObjetosSimilares() {
    this.userDAO.save(this.userTest);
    User ejemplo = new User();
    ejemplo.setName("Pepita");
    ejemplo.setMail("pepitagolondrina@gmail.com");
    final User otherUser = this.userDAO.load(ejemplo);
    String _name = this.userTest.getName();
    String _name_1 = otherUser.getName();
    Assert.assertEquals(_name, _name_1);
    String _lastName = this.userTest.getLastName();
    String _lastName_1 = otherUser.getLastName();
    Assert.assertEquals(_lastName, _lastName_1);
    String _userName = this.userTest.getUserName();
    String _userName_1 = otherUser.getUserName();
    Assert.assertEquals(_userName, _userName_1);
    String _mail = this.userTest.getMail();
    String _mail_1 = otherUser.getMail();
    Assert.assertEquals(_mail, _mail_1);
    Date _birthDate = this.userTest.getBirthDate();
    Date _birthDate_1 = otherUser.getBirthDate();
    Assert.assertEquals(_birthDate, _birthDate_1);
    String _validateCode = this.userTest.getValidateCode();
    String _validateCode_1 = otherUser.getValidateCode();
    Assert.assertEquals(_validateCode, _validateCode_1);
    boolean _isValidate = this.userTest.isValidate();
    boolean _isValidate_1 = otherUser.isValidate();
    Assert.assertEquals(Boolean.valueOf(_isValidate), Boolean.valueOf(_isValidate_1));
    boolean _notEquals = (!Objects.equal(this.userTest, otherUser));
    Assert.assertTrue(_notEquals);
    Assert.assertTrue(true);
  }
  
  @Test
  public void test00SeUpdateaAPepita() {
    this.userDAO.save(this.userTest);
    this.userTest.setName("Dionisia");
    this.userTest.setLastName("golovieja");
    this.userDAO.update(this.userTest);
    User ejemplo = new User();
    ejemplo.setUserName("euforica");
    User otherUser = this.userDAO.load(ejemplo);
    String _name = otherUser.getName();
    Assert.assertEquals(_name, "Dionisia");
    String _lastName = otherUser.getLastName();
    Assert.assertEquals(_lastName, "golovieja");
  }
  
  @After
  public void tearDown() {
    this.userDAO.clearAll();
  }
}
