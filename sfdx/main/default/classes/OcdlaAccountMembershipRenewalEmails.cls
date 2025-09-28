global class OcdlaAccountMembershipRenewalEmails {

     
    // This is the Name assigned to the Opportunity record.  Distinguished from
    // OCDLA Shopping Cart Opportunities.
	private static final String PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME = 'Paid Office Membership Renewal';    
    
    webservice static String previewPaidOfficeRenewalNotificationEmail(String emailTemplateName, String accountId){
        Messaging.SingleEmailMessage theEmail;

        Account theOffice = [SELECT Id, Name, OrderApi__Primary_Contact__c FROM Account WHERE Id = :accountId];
        
        List<Opportunity> renewals = [SELECT Id, AccountId  FROM Opportunity 
                                             WHERE AccountId = :accountId AND Name = :PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME 
                                      	AND StageName != 'Closed Won'
                                             ORDER BY LastModifiedDate DESC LIMIT 1];

        if(null != renewals && renewals.size() > 0){
            Id templateId = ClickpdxMail.getEmailTemplateId(emailTemplateName);
           theEmail = ClickpdxMail.getEmailPreview(templateId, theOffice.OrderApi__Primary_Contact__c, renewals[0].Id);
            return theEmail.getHTMLBody();
        }
        else return '<h2>There are no Paid Office shopping carts for this account, or the shopping carts have been closed.</h2>';
    }
    

    
    webservice static String testPaidOfficeRenewalNotificationEmail(String emailTemplateName, String accountId){
        Messaging.SingleEmailMessage theEmail;

        Account theOffice = [SELECT Id, Name, OrderApi__Primary_Contact__c FROM Account WHERE Id = :accountId];
        
        List<Opportunity> renewals = [SELECT Id, AccountId  FROM Opportunity 
                                             WHERE AccountId = :accountId AND Name = :PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME 
                                             ORDER BY LastModifiedDate DESC LIMIT 1];

        if(renewals.size() > 0){
            Id templateId = ClickpdxMail.getEmailTemplateId(emailTemplateName);
           	return ClickpdxMail.testEmail(templateId, theOffice.OrderApi__Primary_Contact__c, renewals[0].Id);
        }
        else return '<h2>We could not find the related Paid Office Membership Renewal Opportunity...</h2>';
    }
    
    

   webservice static Boolean sendPaidOfficeRenewalNotificationEmail(String emailTemplateName, String accountId){
        Boolean sent = false;
        String email;

        Account theOffice = [SELECT Id, Name, OrderApi__Account_Email__c, OrderApi__Primary_Contact__c FROM Account WHERE Id = :accountId];
        
        List<Opportunity> renewals = [SELECT Id, AccountId, Contact__c  FROM Opportunity 
                                             WHERE AccountId = :accountId AND Name = :PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME 
                                             ORDER BY LastModifiedDate DESC LIMIT 1];

        if(renewals.size() > 0){
            email = theOffice.OrderApi__Account_Email__c != null ? theOffice.OrderApi__Account_Email__c : [SELECT OrderApi__Work_Email__c FROM Contact WHERE Id = :theOffice.OrderApi__Primary_Contact__c LIMIT 1].OrderApi__Work_Email__c;
            Id templateId = ClickpdxMail.getEmailTemplateId(emailTemplateName);
            sent = ClickpdxMail.sendEmail(templateId, renewals[0].Contact__c, renewals[0].Id, email);
        }
        if(sent){
           theOffice.Ocdla_Paid_Office_Renewal_Sent__c = True;
           theOffice.Ocdla_Paid_Office_Renewal_Date_Sent__c = System.now();
           update theOffice;
        }
        return sent;
    }
}