package mailSender;

import mailSender.Mail;

@SuppressWarnings("all")
public interface EmailService {
  public abstract void send(final Mail aMail);
}
