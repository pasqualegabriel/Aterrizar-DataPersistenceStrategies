package Excepciones;

@SuppressWarnings("all")
public class IdenticPasswords extends RuntimeException {
  public IdenticPasswords(final String message) {
    super(message);
  }
}
