package service;

import org.eclipse.xtext.xbase.lib.Exceptions;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.stubbing.OngoingStubbing;
import org.mockito.verification.VerificationMode;
import service.InvalidValidationCode;
import service.Service;
import service.User;
import userDAO.JDBCUserDAO;

@SuppressWarnings("all")
public class TestUserService {
  private Service serviceTest;
  
  @Mock
  private JDBCUserDAO JDBCUserDAOMock;
  
  @Mock
  private User usuarioMock;
  
  @Before
  public void setUp() {
    MockitoAnnotations.initMocks(this);
    Service _service = new Service(this.JDBCUserDAOMock);
    this.serviceTest = _service;
  }
  
  @Test
  public void test000UnServiceSabeQueExisteUnUsuarioConNombreyMail() {
    User _load = this.JDBCUserDAOMock.load("PepitaUser", "pepita@gmail.com");
    OngoingStubbing<User> _when = Mockito.<User>when(_load);
    _when.thenReturn(this.usuarioMock);
    boolean _existeUsuarioCon = this.serviceTest.existeUsuarioCon("PepitaUser", "pepita@gmail.com");
    Assert.assertTrue(_existeUsuarioCon);
  }
  
  @Test
  public void test000UnServiceSabeQueNoExisteUnUsuarioConNombreyMail() {
    RuntimeException excepcion = new RuntimeException();
    User _load = this.JDBCUserDAOMock.load("PepitaUser", "pepita@gmail.com");
    OngoingStubbing<User> _when = Mockito.<User>when(_load);
    _when.thenThrow(excepcion);
    boolean _existeUsuarioCon = this.serviceTest.existeUsuarioCon("PepitaUser", "pepita@gmail.com");
    Assert.assertFalse(_existeUsuarioCon);
  }
  
  @Test
  public void test000SeRegistraUnUsuarioConNombrePepitaExitosamente() {
    RuntimeException excepcion = new RuntimeException();
    User _load = this.JDBCUserDAOMock.load("3", "4");
    OngoingStubbing<User> _when = Mockito.<User>when(_load);
    _when.thenThrow(excepcion);
    User pepita = this.serviceTest.singUp("1", "2", "3", "4", "5");
    VerificationMode _times = Mockito.times(1);
    JDBCUserDAO _verify = Mockito.<JDBCUserDAO>verify(this.JDBCUserDAOMock, _times);
    _verify.save(pepita);
  }
  
  @Test(expected = RuntimeException.class)
  public void test000NoSeRegistraUnUsuarioConNombrePepitaExitosamente() {
    User _load = this.JDBCUserDAOMock.load("3", "4");
    OngoingStubbing<User> _when = Mockito.<User>when(_load);
    _when.thenReturn(this.usuarioMock);
    User pepita = this.serviceTest.singUp("1", "2", "3", "4", "5");
    VerificationMode _times = Mockito.times(0);
    JDBCUserDAO _verify = Mockito.<JDBCUserDAO>verify(this.JDBCUserDAOMock, _times);
    _verify.save(pepita);
  }
  
  @Test
  public void test000UnUsuarioValidaSuCodigoExitosamente() {
    User _loadForCode = this.JDBCUserDAOMock.loadForCode("a");
    OngoingStubbing<User> _when = Mockito.<User>when(_loadForCode);
    _when.thenReturn(this.usuarioMock);
    boolean _validate = this.serviceTest.validate("a");
    Assert.assertTrue(_validate);
  }
  
  @Test
  public void test000UnUsuarioAlValidaSuCodigoNoExisteDichoCodigo() {
    boolean retorno = false;
    RuntimeException excepcion = new RuntimeException();
    User _loadForCode = this.JDBCUserDAOMock.loadForCode("a");
    OngoingStubbing<User> _when = Mockito.<User>when(_loadForCode);
    _when.thenThrow(excepcion);
    try {
      this.serviceTest.validate("a");
    } catch (final Throwable _t) {
      if (_t instanceof InvalidValidationCode) {
        final InvalidValidationCode e = (InvalidValidationCode)_t;
        retorno = true;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    Assert.assertTrue(retorno);
  }
}
