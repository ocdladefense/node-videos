@isTest
public class OcdlaContactTriggerTest {
    
    
    
    public Account a;    
    
    public Contact c;
    
    public SObject tpl;
    
    
    public OcdlaContactTriggerTest() {
        
        
        a = new Account(Name='OCDLA');
        insert a;
        
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
        
        
        tpl = new MessageTemplate__c(Name='Generic Template',Subject__c = 'TEST TEMPLATE EMAIL', HtmlBody__c = 'Hello, {!Contact.Foobar__c}');
        insert tpl;
    }
    
    
    
    @isTest
    static void testContactTrigger() {
        

        OcdlaContactTriggerTest context = new OcdlaContactTriggerTest();
        
        Ocdla_Address_Info__c addy1 = new Ocdla_Address_Info__c(Name='Portland',Ocdla_County__c='Multnomah');
        insert addy1;
        
		context.c.MailingStreet = '123 Alphabet Street';
        context.c.MailingCity = 'Portland';
        context.c.MailingStateCode = 'OR';
        context.c.MailingPostalCode = '97209';
        context.c.MailingCountryCode = 'US';
        context.c.Ocdla_Home_City__c = 'Salem';
        
        update context.c;
    }
    
    /*
    @isTest
    static void testWhoIdWhatId() {
        
        OcdlaContactTriggerTest context = new OcdlaContactTriggerTest();
        Ocdla_Apps__c  cs = Ocdla_Apps__c.getInstance(UserInfo.getProfileId());
        Id whoId = context.c.Id;
        Id whatId = null;
        
        MessageWhoIdWhatId whoIdWhatId = new MessageWhoIdWhatId(whoId,whatId);
        whoIdWhatId.getWhoId();
        whoIdWhatId.getWhatId();
    }
   */ 
}