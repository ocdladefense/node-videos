@isTest(SeeAllData=false)
public class ClickpdxMailTest {
 
    static String recordPrefix = 'TEST002'; 
     
    private static final String MEMBERSHIP_SUBCATEGORY_OPERATOR = 'Membership';
    
    private static final String PRODUCT_OPTION_FLAG = 'Option';
     
     public Account a;
    
    public Contact c;
     
    public Order o;  
    
    public Product2 ticket;
    
    public PricebookEntry entry; 
    
    
    public ClickpdxMailTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];
        this.o = [SELECT Id FROM Order LIMIT 1];
        
//        PriceBook2 nonMember = [SELECT Id, Name FROM PriceBook2 WHERE Name = :OrgOcdla.NON_MEMBER_PRICE_BOOK_NAME LIMIT 1];
        
   //     this.ticket = [SELECT Id, Name, ProductCode FROM Product2 WHERE Id IN(SELECT Product2Id FROM PricebookEntry WHERE PriceBook2Id = :nonMember.Id)];
        
      //  this.entry = [SELECT Id, UnitPrice, Product2.Id, Product2.Name, Product2.OcdlaMembershipStatusGrant__c FROM PricebookEntry LIMIT 1];
      //  
        MessageTemplate__c t = new MessageTemplate__c();
        t.Subject__c = 'Hello World!';
        t.HtmlBody__c = 'The body';
        t.Name = 'Bon30DayFreeTrial';
        insert t;
        
        MessageTemplate__c l = t.clone();
        l.Name = 'OCDLA Email Letterhead';
        l.HtmlBody__c = '<p>{{content}}</p>';
        insert l;

    }
    
    @testSetup static void setup() {
        ClickpdxTest.setup(recordPrefix);
    }
    
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
        ClickpdxMailTest tma;
        Map<Id,Messaging.SingleEmailMessage> newMemberEmails;
        EmailTemplate theTemplate;
        OrderApi__Subscription__c s;
        Contact c;
        
        tma = new ClickpdxMailTest();
        c = tma.c;
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            theTemplate = ClickpdxMail.createEmailTemplate('New Member Welcome Email');
            theTemplate.Subject = 'Welcome {!Contact.FirstName}';
            theTemplate.HtmlValue  = 'Welcome Jose.';
            insert theTemplate;
        }
        
        Test.startTest();
        c.Ocdla_New_or_Renewed__c = 'N';
        update c;
        
        newMemberEmails = ClickpdxMail.getEmailMessages(theTemplate.Id,
                                                         new List<sObject>{(sObject)c});
        
        Messaging.SingleEmailMessage msg = ClickpdxMail.getCompiledEmail(newMemberEmails.get(c.Id));
        
        System.assertEquals(true, newMemberEmails.containsKey(c.Id), 'Email collection should '+
                               'contain key for Contact: '+c.Id);
        String theSubject = msg.getSubject();
        
        System.assertEquals('Welcome '+c.FirstName, theSubject, 'The email merge was not completed successfully.');
        Test.stopTest();
    }
      
    static testMethod void sendRealEmail(){
        ClickpdxMailTest tma;
        Map<Id,Messaging.SingleEmailMessage> newMemberEmails;
        EmailTemplate theTemplate;
        OrderApi__Subscription__c s;
        Contact c;
        
        tma = new ClickpdxMailTest();
        c = tma.c;
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            theTemplate = ClickpdxMail.createEmailTemplate('New Member Welcome Email');
            theTemplate.Subject = 'Welcome {!Contact.FirstName}';
            insert theTemplate;
        }
        
        Test.startTest();
        c.Ocdla_New_or_Renewed__c = 'N';
        update c;

        // Boolean sent = .getCompledEmail(newMemberEmails.get(c.Id));
		Boolean sent = ClickpdxMail.sendEmail(theTemplate.Id, c.Id, tma.o.Id, UserInfo.getUserEmail());
        Test.stopTest();      
    }

    static testMethod void sendTestEmail(){
        ClickpdxMailTest tma;
        Map<Id,Messaging.SingleEmailMessage> newMemberEmails;
        EmailTemplate theTemplate;
        OrderApi__Subscription__c s;
        Contact c;
        
        tma = new ClickpdxMailTest();
        c = tma.c;
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            theTemplate = ClickpdxMail.createEmailTemplate('New Member Welcome Email');
            theTemplate.Subject = 'Welcome {!Contact.FirstName}';
            insert theTemplate;
        }
        
        Test.startTest();
        c.Ocdla_New_or_Renewed__c = 'N';
        update c;

        // Boolean sent = ClickpdxMail.getCompiledEmail(newMemberEmails.get(c.Id));
		String status = ClickpdxMail.testEmail(theTemplate.Id, c.Id, tma.o.Id);
        Test.stopTest();      
    }
    
    static testMethod void getEmailPreview(){
        ClickpdxMailTest context;
        Messaging.SingleEmailMessage theMessage;
        EmailTemplate theTemplate;
        OrderApi__Subscription__c s;
        Contact c;
        
        context = new ClickpdxMailTest();
        c = context.c;
         
        System.runAs(new User(Id=UserInfo.getUserId())){
            theTemplate = ClickpdxMail.createEmailTemplate('New Member Welcome Email');
            theTemplate.Subject = 'Welcome {!Contact.FirstName}';
            insert theTemplate;
        }
        
        Test.startTest();
            c.Ocdla_New_or_Renewed__c = 'N';
            update c;
    
            // theMessage = ClickpdxMail.getEmailPreview(theTemplate.Id, c.Id, tma.o.Id);
            theMessage = ClickpdxMail.getEmailPreview(theTemplate.Id, c.Id, null);
            theMessage = ClickpdxMail.getEmailPreview(theMessage, c.Id, null);
            theMessage= ClickpdxMail.getSingleEmailMessageFromMail(theMessage, new List<String> {'test@abc.com'},c.Id,context.o.Id);
            theMessage = ClickpdxMail.getCompiledEmail(theTemplate.Id, c.Id, context.o.Id);
            Boolean sent = ClickpdxMail.send(theMessage, 'test@abc.com'); 
        
        Test.stopTest();       
    }
     
    
    static testMethod void getOcdlaEmailPreview(){
        ClickpdxMailTest context;

        context = new ClickpdxMailTest();
         
		List<Id> lineIds = new List<Id>{context.c.Id}; 
        
        Test.startTest();
    
            // OcdlaMail.previewEmails(lineIds,'Bon30DayFreeTrial');
            
            // OcdlaMail.testEmails(lineIds,'Bon30DayFreeTrial');
            
            // List<MailSendStatus> statuses = OcdlaMail.sendEmails(lineIds,'Bon30DayFreeTrial');
        
            // System.assertEquals(1,statuses.size(),'There should be at least one email status.');
            // System.assert(statuses[0].isSuccess);
        
        Test.stopTest();      
    }
    
}