package service;

import org.junit.Before;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
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
}
