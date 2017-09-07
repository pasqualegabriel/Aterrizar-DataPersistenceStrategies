package Excepciones;

@SuppressWarnings("all")
public class InvalidValidationCode extends RuntimeException {
  public InvalidValidationCode(final String message) {
    super(message);
  }
}
