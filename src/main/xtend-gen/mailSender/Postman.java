package mailSender;

import Excepciones.SendMailException;
import mailSender.EmailService;
import mailSender.Mail;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class Postman implements EmailService {
  @Override
  public void send(final Mail aMail) {
    try {
    } catch (final Throwable _t) {
      if (_t instanceof RuntimeException) {
        final RuntimeException e = (RuntimeException)_t;
        throw new SendMailException("No se pudo enviar el mail");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
}
