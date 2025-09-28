@isTest
public class DonationLetterTest {

    public Account a;    
    
    public Contact c;
    
    public DocumentTemplate__c docTpl;
    
    public DocumentInstance__c letter;
    

    public DonationLetterTest() {
  

       	a = new Account(Name='OCDLA');
        insert a;
        
        // Member Contact expiring in 6 months.
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        c.Ocdla_Membership_Expiration_Date__c = Date.today().addMonths(6);
        c.Ocdla_Member_Status__c = 'R';
        insert c;
        
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
	private static void doTest() {
        
        DonationLetterTest context = new DonationLetterTest();

        DocumentTemplateProcessor template = new DocumentTemplateProcessor(context.docTpl.Id, context.c.Id, context.letter.Id);
        template.getAvailableMergeFields();
        template.getMessageBody();
        
        Mergeable myMerge = (Mergeable)template;
        
        PageReference thePage = Page.DocumentLetter;
        thePage.getParameters().put('tplId', context.docTpl.Id);
        thePage.getParameters().put('contactId', context.c.Id);
        thePage.getParameters().put('whatId', context.letter.Id);

        
        Test.setCurrentPage(thePage);
        
        template = new DocumentTemplateProcessor();
    }
    
    
}