public class MembershipRenewalMailAction implements IMailEventAction {

    
    public void afterSend(List<MailSendStatus> results) {
        
		List<Contact> affectedContacts = new List<Contact>();
         
        for(MailSendStatus status :results) {
            Contact c = new Contact(Id=status.targetObjectId);
            c.RenewalEmailSent__c = True;
            c.RenewalEmailSentDate__c = System.now();
            affectedContacts.add(c);
        }
        
        update affectedContacts;
    }
}