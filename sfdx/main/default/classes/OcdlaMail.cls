/**
 * 
 */
global without sharing class OcdlaMail {
    
  
      
    @future
    public static void sendEmailsAsync(List<Id> orderItemIds, String generator){
        MailApiConfig config = new MailApiConfig();
        config.generator = generator;
        
        OcdlaMail.sendEmails(orderItemIds,config);
    }
    
      

    
    
    static MailGenerator getGenerator(MailApiConfig config) {
       
        Type t;
        MailGenerator generator;
        
        t = Type.forName(config.generator);
        generator = (MailGenerator)t.newInstance();
        
        if(null != config.template) {
        	generator.setTemplate(config.template);
        }
        
        return generator;
    }
    
    
    
    static IMailEventAction getEmailEventActionInstance(MailApiConfig config) {
       
        Type t;
        IMailEventAction afterSend;
        
        if(null == config.afterSend) return null;
        
        t = Type.forName(config.afterSend);
        
        if(null == t) return null;
        
        return (IMailEventAction)t.newInstance();
    }
    

    
    /**  
     * sendEmails
     */
    webservice static List<MailSendStatus> sendEmails(List<Id> recordIds, MailApiConfig config) {
        

        MailGenerator generator = getGenerator(config);
        generator.setRecordIds(recordIds);
        
		List<MailMessage> messages = generator.getMessages();

        IMailEventAction mailEvent = getEmailEventActionInstance(config);
        
        
        
        if(null == messages || messages.size() < 1) {
            System.debug(messages);
            return null;
        }
        
		MailClient client = new MailClient();
        
        List<MailSendStatus> results = client.send(generator);
        
        // If an explicit afterSend class was specified we MUST use that.
        if(null != mailEvent) {
            mailEvent.afterSend(results);
        } else {
        	generator.afterSend(results);
        }
        
        return results;
    }

    
    
    webservice static List<MailSendStatus> testEmails(List<Id> recordIds, MailApiConfig config) {
        
		MailClient client = new MailClient();
        
        List<MailMessage> messages = generateTestEmails(recordIds, config);
        
        return client.send(messages);
    }
    
    
    
    /**
     * testEmails
     */
    public static List<MailMessage> generateTestEmails(List<Id> recordIds, MailApiConfig config) {
        
        Savepoint sp;
        MessageWhoIdWhatId sample;
        List<MailMessage> messages = new List<MailMessage>();
        String errorMessage;

        Boolean useSample = null == config.sample ? False : config.sample;
        
        MailGenerator generator = getGenerator(config);

        System.debug(generator);


        sp = Database.setSavepoint();
        
		MailClient client = new MailClient();
        
        if(useSample) {
            sample = generator.getSampleWhoIdWhatId(recordIds); 
        }
        
        List<Id> whatIds = useSample ? new List<Id>{sample.getWhatId()} : recordIds;   
        generator.setRecordIds(whatIds);
        
        MailMessageIterator it = generator.iterator();

        while(it.hasNext()) {
            MailMessage email = it.next();
            if(null == email.getWhoId()) {
                throw new MailApiException('EMAIL_ERROR: WhoId not set.');
            }
            email.setSampled(useSample);
            email.setTest(True);
            email.setTo(UserInfo.getUserEmail());
            messages.add(email);
        }
        
        Database.rollback(sp);
        
        return messages;
    }
    
  

      
    webservice static String[] previewEmails(List<Id> recordIds, MailApiConfig config){

        Savepoint sp;
        String[] bodies = new String[]{};
        MessageWhoIdWhatId sample;
        List<MailMessage> emails;
        String errorMessage;
        List<Id> whatIds;
        Boolean useSample = null == config.sample ? False : config.sample;
        
        MailGenerator generator = getGenerator(config);
        
        sp = Database.setSavepoint();
        
		MailClient client = new MailClient();

        try {
        
            if(useSample) {
				sample = generator.getSampleWhoIdWhatId(recordIds); 
            }
            
            whatIds = useSample ? new List<Id>{sample.getWhatId()} : recordIds;  
        	generator.setRecordIds(whatIds);

			MailMessageIterator it = generator.iterator();
            
            while(it.hasNext()) {
                MailMessage email = it.next();   
                
                if(null == email.getWhoId()){
                    throw new MailApiException('EMAIL_ERROR: WhoId not set.');
                }
                // String body = null == email.getTemplate() ? email.mergeBody() : email.getBody();
                // String subject = null == email.getTemplate() ? email.mergeSubject() : email.getSubject();
                bodies.add(client.useLetterhead(email.getBody()));
            }

        } catch(Exception e) {
			errorMessage = e.getTypeName() + ': '+e.getMessage();
            bodies.add(errorMessage);
        }  

        Database.rollback(sp);
        
        return bodies;
    }

    
    
    private class MailApiException extends Exception {}
    
}