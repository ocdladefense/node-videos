@isTest
private class OcdlaAttendeeTest {
        
    private static User u;  
      
    private static Profile theProfile;
    
    private static sObject settings;  
    
    private static EmailTemplate validEmailTemplate;
    
    private static Account testAccount;  
    
    private static Contact theCustomer;
    
    private static String recordPrefix = 'TEST004';
    
    public Event__c evt; 
    
    public Account a;
    
    public Contact c;
    
    public Product2 p; 
    
    public Order o;
    
    public Event__c e;
    
    List<OrderItem> lines;
    
    public PricebookEntry entry;
    
    public MessageTemplate__c letterhead;
    
    
    public OcdlaAttendeeTest() {
        
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        
        this.c = [SELECT Id, Name FROM Contact LIMIT 1];
        
        this.p = [SELECT Id, Name, Event__c, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        
        this.o = [SELECT Id, OrderNumber, OpportunityId FROM Order LIMIT 1];
        
        this.e = [SELECT Id FROM Event__c LIMIT 1];
        this.e.EventConfirmationEmail__c = '{!OrderItem.FirstName__c}';
        this.e.EventConfirmationEmailSubject__c = 'OCDLA Annual Conference - June 14–16, 2018, Bend';//{!Contact.FirstName}';
        update this.e;
        
        this.p.Event__c = this.e.Id;
        update this.p;
        
        this.entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :this.p.Id LIMIT 1];
        
        this.lines = [SELECT Id, OrderId, PricebookEntryId, Description, UnitPrice, TotalPrice, Quantity, Contact__c,
                      FirstName__c, LastName__c FROM OrderItem WHERE OrderId = :this.o.Id];
        
        MessageTemplate__c template = new MessageTemplate__c(Name='OCDLA Email Letterhead',Subject__c='Action Required',HtmlBody__c='{{content}}');
        insert template;
        
        this.letterhead = template;
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }

    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxTest.setup(recordPrefix);        
    }

    
    @isTest
    private static void autofillNames(){
        OcdlaAttendeeTest context = new OcdlaAttendeeTest();
        OrderItem line = context.lines[0].clone(False,True);
        line.Contact__c = context.c.Id;
        line.PricebookEntryId = context.entry.Id;
        insert line;
        
        Test.startTest();
        	OcdlaAttendee.doAutofillNames(context.p.Event__c);
        Test.stopTest();
    } 
    
    
    @isTest
    private static void previewEmails() {
          
        OcdlaAttendeeTest context = new OcdlaAttendeeTest();
        OrderItem line = context.lines[0].clone(False,True);
        line.Contact__c = context.c.Id;	
        line.PricebookEntryId = context.entry.Id;
        insert line;
        

        Test.startTest();
         
        	MailApiConfig preview = new MailApiConfig();
        	preview.sample = True;
			preview.generator = 'AttendeeConfirmationEmail';
        
			// OcdlaMail.getEmailsFromGenerator('AttendeeConfirmationEmail', new List<Id>{line.Id}, preview);
            OcdlaMail.sendEmailsAsync(new List<Id>{line.Id},'AttendeeConfirmationEmail');
        
			// Should we test the return values of the above method calls?
            OcdlaMail.previewEmails(new List<Id>{context.p.Id}, preview);
        
        Test.stopTest();
    }
     

    @isTest
    private static void testEmails() { 
        
        OcdlaAttendeeTest context = new OcdlaAttendeeTest();
        OrderItem line = context.lines[0].clone(False,True);
        line.Contact__c = context.c.Id;
        line.PricebookEntryId = context.entry.Id;
        insert line;
        
        MailClient client = new MailClient();
        
        Test.startTest();  
        
        	MailApiConfig defaultConfig = new MailApiConfig();
        	defaultConfig.generator = 'AttendeeConfirmationEmail';
        
            OcdlaMail.testEmails(new List<Id>{line.Id}, defaultConfig);  
			List<MailMessage> messages = OcdlaMail.generateTestEmails(new List<Id>{line.Id}, defaultConfig);
        	
            for(MailMessage m : messages) {
                Messaging.SingleEmailMessage msg = client.toSingleEmailMessage(m);
                client.serialize(m);
            }
		Test.stopTest();
    }
    
    
    @isTest
    private static void sendEmails() {
        
        OcdlaAttendeeTest context = new OcdlaAttendeeTest();
        OrderItem line = context.lines[0].clone(False,True);
        line.Contact__c = context.c.Id;
        line.PricebookEntryId = context.entry.Id;
        insert line;
        
        Test.startTest();
        
        	MailApiConfig defaultConfig = new MailApiConfig();
        	defaultConfig.generator = 'AttendeeConfirmationEmail';
        
        	OcdlaMail.sendEmails(new List<Id>{line.Id}, defaultConfig);
        
        Test.stopTest();

    } 



}