@isTest
public class PaidOfficeRenewalEmailTest {
    

        
    public Account a;    
    
    public Contact c;
    
   	public SObject tpl;
    
    public Opportunity o;
    

    public PaidOfficeRenewalEmailTest() {
  

       	a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
        
        a.OrderApi__Primary_Contact__c = c.Id;
        update a;
         
        tpl = new MessageTemplate__c(Name='Generic Template',Subject__c = 'TEST TEMPLATE EMAIL', HtmlBody__c = 'Hello, {!Opportunity.Account}');
        insert tpl;
        
		o = new Opportunity(AccountId=a.Id, Contact__c=a.OrderApi__Primary_Contact__c, Name=PaidOfficeRenewalEmail.PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME);
        o.StageName = 'Prospecting';
        o.CloseDate = Date.today()+1;
        insert o;
        
    }
        
     

    
    @isTest
    static void testWhoIdWhatId() {
        
        PaidOfficeRenewalEmailTest context = new PaidOfficeRenewalEmailTest();
        
        Id whoId = context.a.Id;
        Id whatId = context.o.Id;
        
        MessageWhoIdWhatId whoIdWhatId = new MessageWhoIdWhatId(whoId,whatId);
        whoIdWhatId.getWhoId();
        whoIdWhatId.getWhatId();
    }
      
    
    
    @isTest
    static void testGetData() {
        
        PaidOfficeRenewalEmail generator = new PaidOfficeRenewalEmail();
    }
        
      
      
    @isTest
    static void previewEmails() {
        
        Test.startTest(); 
        
        	PaidOfficeRenewalEmailTest context = new PaidOfficeRenewalEmailTest(); 
        	PaidOfficeRenewalEmail generator = new PaidOfficeRenewalEmail(context.a.Id);
        	generator.getMessages();
        
        	MailApiConfig preview = new MailApiConfig();
        
        	preview.sample = True;  
			preview.generator = 'PaidOfficeRenewalEmail';
        	preview.template = 'Generic Template';
        	
			// Should we test the return values of the above method calls?
            MailApi.previewEmails(new List<Id>{context.a.Id}, preview);

        
        Test.stopTest();  
    }
    
    
    
    @isTest
    static void testEmails() {
      
        PaidOfficeRenewalEmailTest context = new PaidOfficeRenewalEmailTest();
  
        Test.startTest();  

        	PaidOfficeRenewalEmail generator = new PaidOfficeRenewalEmail(context.a.Id); 
        	MailApiConfig testConfig = new MailApiConfig();
        
        	testConfig.sample = False;
			testConfig.generator = 'PaidOfficeRenewalEmail';
        	testConfig.template = 'Generic Template';  
        
            MailApi.testEmails(new List<Id>{context.a.Id}, testConfig);

        Test.stopTest();  
    }
     
       
    @isTest
    static void sendEmails() {
     
        PaidOfficeRenewalEmailTest context = new PaidOfficeRenewalEmailTest();
  
        Test.startTest();

        	PaidOfficeRenewalEmail generator = new PaidOfficeRenewalEmail(context.a.Id);
        	MailApiConfig config = new MailApiConfig();
        
        	config.sample = False;  
			config.generator = 'PaidOfficeRenewalEmail';
        	config.template = 'Generic Template';
        	config.afterSend = 'PaidOfficeRenewalMailAction';
        
        	MailApi.sendEmails(new List<Id>{context.a.Id}, config);

        
        Test.stopTest();
    }
    

}