package service;

import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@Accessors
@SuppressWarnings("all")
public class User {
  private String name;
  
  private String lastName;
  
  private String userName;
  
  private String pasword;
  
  private String mail;
  
  private String birthDate;
  
  private boolean validate;
  
  public User(final String name, final String lastName, final String userName, final String mail, final String birthDate) {
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
  public String getPasword() {
    return this.pasword;
  }
  
  public void setPasword(final String pasword) {
    this.pasword = pasword;
  }
  
  @Pure
  public String getMail() {
    return this.mail;
  }
  
  public void setMail(final String mail) {
    this.mail = mail;
  }
  
  @Pure
  public String getBirthDate() {
    return this.birthDate;
  }
  
  public void setBirthDate(final String birthDate) {
    this.birthDate = birthDate;
  }
  
  @Pure
  public boolean isValidate() {
    return this.validate;
  }
  
  public void setValidate(final boolean validate) {
    this.validate = validate;
  }
}
