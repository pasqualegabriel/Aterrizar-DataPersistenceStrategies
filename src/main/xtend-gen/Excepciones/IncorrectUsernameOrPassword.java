package Excepciones;

@SuppressWarnings("all")
public class IncorrectUsernameOrPassword extends RuntimeException {
  public IncorrectUsernameOrPassword(final String message) {
    super(message);
  }
}
