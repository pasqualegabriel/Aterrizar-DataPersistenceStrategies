package Excepciones;

@SuppressWarnings("all")
public class SendMailException extends RuntimeException {
  public SendMailException(final String message) {
    super(message);
  }
}
