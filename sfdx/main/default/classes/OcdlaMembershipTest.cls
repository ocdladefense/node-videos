@isTest(SeeAllData=false)
public class OcdlaMembershipTest {
    
    /**
* 
* @testMethod - accountMembershipRenewal
* 
* @description - 
* 	  Create a membership renewal Sales Order.
* 		 The default Sales Order will be in open status.  This method should 
* 			create a Sales Order with lines corresponding to membership renewals for
*          each Contact in the Account.
* 
*/    
    static testMethod void contactIsNewMember(){
        Clickpdx_Test_Base tma;
        Map<Id,Messaging.SingleEmailMessage> newMemberEmails;
        EmailTemplate theTemplate;
        OrderApi__Subscription__c s;
        Contact c;
        
        tma = new Clickpdx_Test_Base();
        c = tma.c;
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            theTemplate = Clickpdx_Test_Base.createEmailTemplate('New Member Welcome Email');
            theTemplate.Subject = 'Welcome {!Contact.FirstName}';
            insert theTemplate;
        }
        
        Test.startTest();
        c.Ocdla_New_or_Renewed__c = 'N';
        update c;
        
        newMemberEmails = Clickpdx_Mail.getEmailMessages(theTemplate.Id,
                                                         new List<sObject>{(sObject)c});
        
        Messaging.SingleEmailMessage msg = Clickpdx_Mail.getCompiledEmail(newMemberEmails.get(c.Id));
        
        System.assertEquals(true, newMemberEmails.containsKey(c.Id), 'Email collection should '+
                               'contain key for Contact: '+c.Id);
        String theSubject = msg.getSubject();
        
        System.assertEquals('Welcome '+c.FirstName, theSubject, 'The email merge was not completed successfully.');
        Test.stopTest();
    }
}