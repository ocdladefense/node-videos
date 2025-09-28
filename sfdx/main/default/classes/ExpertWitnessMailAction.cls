public class ExpertWitnessMailAction implements IMailEventAction {
    
    public void afterSend(List<MailSendStatus> results) {
        
		List<MailMessage__c> messages = new List<MailMessage__c>();
         
        for(MailSendStatus status :results) {

            MailMessage__c m = new MailMessage__c(Contact__c=status.targetObjectId, 
                                                  Subject__c=status.subject,
                                                  Body__c=status.body,
                                                  DateSent__c=status.dateSent,
                                                  Status__c=status.message);
                                                  m.Name = status.subject + ' - ' + status.dateSent.format();
            
            messages.add(m);
        }  
        
        insert messages;
    }
}