public class PaidOfficeRenewalEmail extends MailGenerator {

    
    // This is the Name assigned to the Opportunity record.  Distinguished from
    // OCDLA Shopping Cart Opportunities.
    @testVisible
	private static final String PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME = 'Paid Office Membership Renewal';  

    
    
    public PaidOfficeRenewalEmail(Id accountId) {
		this.recordIds.add(accountId);
    }
    
    public PaidOfficeRenewalEmail() {}  
    
    
    
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> accountId) {
        

        Account theOffice = [SELECT Id, Name, OrderApi__Primary_Contact__c FROM Account WHERE Id = :accountId];
  
        
        List<Opportunity> renewals = [SELECT Id, AccountId  FROM Opportunity 
                                             WHERE AccountId = :accountId AND Name = :PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME 
                                      	AND StageName != 'Closed Won'
                                             ORDER BY LastModifiedDate DESC LIMIT 1];
        
		// The email will be sent to the primary Contact for the specified Opportunity.
        return new MessageWhoIdWhatId(theOffice.OrderApi__Primary_Contact__c, renewals[0].Id);
    }
    

  

      
    public override List<MailMessage> getMessages() {
    

        Map<Id,Opportunity> renewals = new Map<Id,Opportunity>([SELECT Id, AccountId, Account.OrderApi__Account_Email__c, Contact__c, Contact__r.Email FROM Opportunity 
                                             WHERE AccountId = :this.recordIds AND Name = :PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME 
                                      	AND StageName != 'Closed Won'
                                             ORDER BY LastModifiedDate DESC LIMIT 1]);
        
        // May need to calculate the optional account email.
        // Account emails are specified at the account level and are not associated with a Contact.
        // Account.OrderApi__Account_Email__c
		List<MailMessage> emails = new List<MailMessage>();

        for(Opportunity o :renewals.values()){
			MailMessage msg = new MailMessage(o.Contact__c, o.Id);
            msg.setTo(null == o.Account.OrderApi__Account_Email__c ? o.Contact__r.Email : o.Account.OrderApi__Account_Email__c);
            emails.add(msg);
        }

        return emails;
    }
    

    
    
    public override void afterSend(List<MailSendStatus> results) {
        

    }

    

}