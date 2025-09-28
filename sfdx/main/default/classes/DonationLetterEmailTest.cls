@isTest
public class DonationLetterEmailTest {
    

    
    public Account a;    
    
    public Contact c;
    
   	public SObject tpl;
    
    public DocumentTemplate__c docTpl;
    
    public DocumentInstance__c letter;
    

    public DonationLetterEmailTest() {
  

       	a = new Account(Name='OCDLA');
        insert a;
        
        // Member Contact expiring in 6 months.
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        c.Ocdla_Membership_Expiration_Date__c = Date.today().addMonths(6);
        c.Ocdla_Member_Status__c = 'R';
        insert c;
        
         
        tpl = new MessageTemplate__c(Name='2024 Donation Letter Email',Subject__c = '2024 Donation Letter Email');
        tpl.put('HtmlBody__c','Hello, {!Contact.FirstName__c}');
        insert tpl;  
        
        docTpl = new DocumentTemplate__c(Name='Donation Summary 2024',Subject__c='Donation Summary 2024');
        docTpl.HtmlBody__c = 'Hello {!Contact.FirstName}, We are writing you.';
        docTpl.EffectiveDate__c = Date.today();
        docTpl.Signatures__c = 'Shaun McCrea';
        insert docTpl;  
        
        letter = new DocumentInstance__c(Name='2024 Donation Summary Letter for Jose Bernal');
        letter.DocumentTemplate__c = docTpl.Id;
        letter.Contact__c = c.Id;
        insert letter;
    }
        
     

    
    @isTest
    static void testWhoIdWhatId() {
        
        DonationLetterEmailTest context = new DonationLetterEmailTest();
        
        Id whoId = context.c.Id;
        Id whatId = context.letter.Id;
        
        MessageWhoIdWhatId whoIdWhatId = new MessageWhoIdWhatId(whoId,whatId);
        whoIdWhatId.getWhoId();
        whoIdWhatId.getWhatId();
    }
      
    
    
    @isTest
    static void testGetData() {
        
        DonationLetterEmailTest generator = new DonationLetterEmailTest();
    }
        
      
      
    @isTest
    static void previewEmails() {
        
        Test.startTest(); 
        
        	DonationLetterEmailTest context = new DonationLetterEmailTest(); 
        	DonationLetterEmail generator = new DonationLetterEmail(context.letter.Id);
        	generator.getMessages();
        
        	MailApiConfig preview = new MailApiConfig();
        
        	preview.sample = True;  
			preview.generator = 'DonationLetterEmail';
        	preview.template = '2024 Donation Letter Email';
        	
			// Should we test the return values of the above method calls?
            MailApi.previewEmails(new List<Id>{context.letter.Id}, preview);

        
        Test.stopTest();  
    }
    
    
    
    @isTest
    static void testEmails() {
      
        DonationLetterEmailTest context = new DonationLetterEmailTest();
  
        Test.startTest();  

        	DonationLetterEmail generator = new DonationLetterEmail(context.letter.Id); 
        	MailApiConfig testConfig = new MailApiConfig();
        
        	testConfig.sample = False;
			testConfig.generator = 'DonationLetterEmail';
        	testConfig.template = '2024 Donation Letter Email';  
        
            MailApi.testEmails(new List<Id>{context.letter.Id}, testConfig);

        Test.stopTest();  
    }
    
       
    @isTest
    static void sendEmails() {
     
        DonationLetterEmailTest context = new DonationLetterEmailTest();

        Test.startTest();
  
        	DonationLetterEmail generator = new DonationLetterEmail(context.letter.Id);
        	MailApiConfig config = new MailApiConfig();
        
        	config.sample = False;  
			config.generator = 'DonationLetterEmail';
        	config.template = '2024 Donation Letter Email';
        	// config.afterSend = 'MembershipRenewalMailAction'; // Need to update
        
        	MailApi.sendEmails(new List<Id>{context.letter.Id}, config);
        
			// Need to update this block
        	// config.afterSend = 'ExpertWitnessMailAction';
        	// MailApi.sendEmails(new List<Id>{context.c.Id}, config);
        
        Test.stopTest();
    }
    

}