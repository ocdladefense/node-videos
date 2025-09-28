public class PaidOfficeRenewalMailAction implements IMailEventAction {
    
    public void afterSend(List<MailSendStatus> results) {
        
		List<MailMessage__c> messages = new List<MailMessage__c>();

         
        for(MailSendStatus status :results) {
			String emailName = status.subject + ' ' + status.dateSent.format();
            emailName = emailName.substring(0, (emailName.length() >= 80 ? 79 : emailName.length()-1));
            
            MailMessage__c m = new MailMessage__c(Contact__c=status.targetObjectId, 
                                                  Subject__c=status.subject,
                                                  Body__c=status.body,
                                                  DateSent__c=status.dateSent,
                                                  Status__c=status.message);
          m.Name = emailName;
            
            messages.add(m);
            
            
            Opportunity invoice = [SELECT Id, AccountId FROM Opportunity WHERE Id=:status.whatId];
            
            Account a = new Account(Id=invoice.AccountId);
            a.Ocdla_Paid_Office_Renewal_Sent__c = True;
            a.Ocdla_Paid_Office_Renewal_Date_Sent__c = System.now();
            update a;
        }  
        
        insert messages;

    }
}