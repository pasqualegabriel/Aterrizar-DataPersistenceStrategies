package mailSender

class Mail {
	
	String subject
	String body
	String to
	String from

	new(String aSubject, String aBody, String aTo, String aFrom) {
		
		subject = aSubject
		body	= aBody
		to		= aTo	
		from	= aFrom
	}

}
