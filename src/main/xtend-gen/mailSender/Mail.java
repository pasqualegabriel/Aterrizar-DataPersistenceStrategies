package mailSender;

@SuppressWarnings("all")
public class Mail {
  private String subject;
  
  private String body;
  
  private String to;
  
  private String from;
  
  public Mail(final String aSubject, final String aBody, final String aTo, final String aFrom) {
    this.subject = aSubject;
    this.body = aBody;
    this.to = aTo;
    this.from = aFrom;
  }
}
