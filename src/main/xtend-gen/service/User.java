package service;

import java.util.Date;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@Accessors
@SuppressWarnings("all")
public class User {
  private String name;
  
  private String lastName;
  
  private String userName;
  
  private String userPassword;
  
  private String mail;
  
  private Date birthDate;
  
  private String validateCode;
  
  private boolean validate;
  
  public User() {
    super();
  }
  
  public User(final String name, final String lastName, final String userName, final String mail, final Date birthDate) {
    this.name = name;
    this.lastName = lastName;
    this.userName = userName;
    this.mail = mail;
    this.birthDate = birthDate;
    this.validate = false;
  }
  
  @Pure
  public String getName() {
    return this.name;
  }
  
  public void setName(final String name) {
    this.name = name;
  }
  
  @Pure
  public String getLastName() {
    return this.lastName;
  }
  
  public void setLastName(final String lastName) {
    this.lastName = lastName;
  }
  
  @Pure
  public String getUserName() {
    return this.userName;
  }
  
  public void setUserName(final String userName) {
    this.userName = userName;
  }
  
  @Pure
  public String getUserPassword() {
    return this.userPassword;
  }
  
  public void setUserPassword(final String userPassword) {
    this.userPassword = userPassword;
  }
  
  @Pure
  public String getMail() {
    return this.mail;
  }
  
  public void setMail(final String mail) {
    this.mail = mail;
  }
  
  @Pure
  public Date getBirthDate() {
    return this.birthDate;
  }
  
  public void setBirthDate(final Date birthDate) {
    this.birthDate = birthDate;
  }
  
  @Pure
  public String getValidateCode() {
    return this.validateCode;
  }
  
  public void setValidateCode(final String validateCode) {
    this.validateCode = validateCode;
  }
  
  @Pure
  public boolean isValidate() {
    return this.validate;
  }
  
  public void setValidate(final boolean validate) {
    this.validate = validate;
  }
}
