@IsTest
public class ProductConfirmationEmailTest {
     
    private static String recordPrefix = 'TEST003'; 
    
    public Account a;    
        
    public Contact c;      
      
    public Product2 p;
    
    public Order o;
      
    public PricebookEntry entry;
    
    public List<OrderItem> lines;
    
    public OrderItem theLine;
    
    MessageTemplate__c letterhead;
    
    MessageTemplate__c productTemplate;
      
     
    public ProductConfirmationEmailTest() {
        
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';

       	a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
            
        
        this.p = [SELECT Id, Name, Event__c, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        this.p.ConfirmationEmailSubject__c = '{!Contact.FirstName}';
        this.p.ConfirmationEmailBody__c = '{!OrderItem.FirstName__c}';
        update this.p;
         
        Order o = new Order(AccountId=a.Id,Status='Draft',EffectiveDate=System.today());
        o.Pricebook2Id = ClickpdxCore.Application.config.getStdPricebookId();
        insert o;
         
        this.entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :this.p.Id];
        upsert this.entry;
        
        this.theLine = new OrderItem(PricebookEntryId=this.entry.Id,UnitPrice=1.00,Quantity=1.00,Contact__c=c.Id,FirstName__c='Jane',LastName__c='Doe');
        this.theLine.OrderId = o.Id;
        insert this.theLine;
    }
        
     
    @testSetup
    static void setup() {
        testSetup();
    }    
       
    public static void testSetup() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxCore.TestBase.setup(recordPrefix);        
    }
      
    @isTest
    static void testWhoIdWhatId() {
        
        ProductConfirmationEmailTest context = new ProductConfirmationEmailTest();
        
        Id whoId = context.c.Id;
        Id whatId = context.theLine.Id;
        
        MessageWhoIdWhatId whoIdWhatId = new MessageWhoIdWhatId(whoId,whatId);
        whoIdWhatId.getWhoId();
        whoIdWhatId.getWhatId();
    }

     
    
    @isTest
    static void testGenerator() {
        
        ProductConfirmationEmailTest context = new ProductConfirmationEmailTest();
  
        Test.startTest();
         
        	ProductConfirmationEmail generator = new ProductConfirmationEmail();
        	generator.setRecordIds(new List<Id>{context.theLine.Id});
            List<MailMessage> messages = generator.getMessages();
        
        Test.stopTest();
    }
    
    
    @isTest
    static void previewEmails() {
        ProductConfirmationEmailTest context = new ProductConfirmationEmailTest();

        Test.startTest();
         
        	MailApiConfig preview = new MailApiConfig();
			preview.generator = 'ProductConfirmationEmail';
        	preview.sample = True;

			// OcdlaMail.getEmailsFromGenerator('ProductConfirmationEmail', new List<Id>{context.theLine.Id}, preview);
            OcdlaMail.sendEmailsAsync(new List<Id>{context.theLine.Id},'ProductConfirmationEmail');
        
			// Should we test the return values of the above method calls?
            OcdlaMail.previewEmails(new List<Id>{context.p.Id}, preview);
        Test.stopTest();
    }
       
      
    
    @isTest
    static void testEmails() {
        ProductConfirmationEmailTest context = new ProductConfirmationEmailTest();

        Test.startTest();
        
        	MailApiConfig defaultConfig = new MailApiConfig();
        	defaultConfig.generator = 'ProductConfirmationEmail';
        	defaultConfig.sample = False;
        
            OcdlaMail.testEmails(new List<Id>{context.theLine.Id}, defaultConfig);

		Test.stopTest();  
    }
      
    
    @isTest
    static void testEmailsWithSample() {
        ProductConfirmationEmailTest context = new ProductConfirmationEmailTest();

        Test.startTest();
        
        	MailApiConfig defaultConfig = new MailApiConfig();
        	defaultConfig.generator = 'ProductConfirmationEmail';
        	defaultConfig.sample = True;
        
        	// Note: to get a sample we pass the productId in, not the lineId.
            OcdlaMail.testEmails(new List<Id>{context.p.Id}, defaultConfig);

		Test.stopTest();  
    }  
    
      
        
    @isTest
    static void sendEmails() {
        ProductConfirmationEmailTest context = new ProductConfirmationEmailTest();

        Test.startTest();
        
        	MailApiConfig defaultConfig = new MailApiConfig();
        	defaultConfig.generator = 'ProductConfirmationEmail';
        
        	OcdlaMail.sendEmails(new List<Id>{context.theLine.Id}, defaultConfig);
        
        Test.stopTest();
    }
    
}