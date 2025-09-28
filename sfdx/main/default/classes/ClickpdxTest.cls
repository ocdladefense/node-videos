@isTest
public without sharing class ClickpdxTest {
    public static Account a;
    
    public static Contact c; 
    
    public static User portalUser;
    
    public static User systemUser;

    public static String PORTAL_USER_PROFILE_NAME = 'MN Customer Community Login User';
    
    public static String SYSTEM_USER_PROFILE_NAME = 'System Administrator';
    
    public static Set<Id> eventTicketTypeIds;
    
    public static Map<Id,Product2> ticketTypeItems;
    
    static final Id MEMBERSHIP_ITEM_ID = 'a0wj00000004rqx';

    static final String GUEST_PROFILE_NAME = 'OCDLA Member Community Profile';

    
    
    public static void initData(){
        a = new Account();
        a.Name = 'bucket account';
        a.BillingCountry = 'United States';
        a.OwnerId = UserInfo.getUserId();
        // a.billingState='VA';
        insert a;
        
        c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'McTesty';
        c.AccountId = a.Id;
        c.Email = 'tmctesty@abc.com';
        c.OrderApi__Work_Email__c = 'tmctesty@abc.com';
        c.Ocdla_Member_Status__c = 'A';
        c.MailingCity = 'Portland';
        c.MailingStateCode = 'OR';
        c.MailingPostalCode = '97209';
        c.MailingStreet = '1040 NW 10 AVE APT 219';
        
        insert c; 
        
        eventTicketTypeIds = new Set<Id>{};
                
		ticketTypeItems = new Map<Id,Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :eventTicketTypeIds]);
        
        
        a.OrderApi__Primary_Contact__c = c.Id;
        update a; 
        
        System.assertEquals(c.AccountId,a.Id);

    }
    

    
    public static User getStaticGuestUser(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:GUEST_PROFILE_NAME LIMIT 1]; 
        User u = new User(Alias = 'WGWeb', Email='WGWebUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='WGWebUser', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='WGWebUser@testorg.com');
        return u;
            
	}
    
    public static User getPortalUser(Contact c){
        // Insert a new User record.
        System.debug(UserInfo.getProfileId());
        
        Profile p = [SELECT Id,Name FROM Profile WHERE Name=:PORTAL_USER_PROFILE_NAME]; 
        // System.assertEquals(UserInfo.getProfileId(),p.Id);
        System.assertEquals(p.Name,PORTAL_USER_PROFILE_NAME);
        
        User portalUser = new User(Alias = 'standt',
                                   Email='standarduser@testorg.com', 
                                   EmailEncodingKey='UTF-8',
                                   LastName='Testing',
                                   LanguageLocaleKey='en_US', 
                                   LocaleSidKey='en_US',
                                   ProfileId = p.Id, 
                                   TimeZoneSidKey='America/Los_Angeles',
                                   UserName='abcxstandarduser@testorg.com',
                                   ContactId=c.Id);
        
        return portalUser;
    }


    public static SObject createSObject(String SObjectName){
        if('Product2' == SObjectName){
            return new Product2(Name='My Test Product');
        }
        else if('Account' == SObjectName){
            Account a = new Account();
            a.Name = 'Test Account';
            a.BillingCountry = 'United States';
            a.OwnerId = UserInfo.getUserId();
            // a.billingState = 'VA';
            return a;
        }
        else if('Contact' == SObjectName){
            Contact c = new Contact();
            c.FirstName = 'Test';
            c.LastName = 'McTesty';
            c.Email = 'tmctesty@abc.com';
            c.OrderApi__Work_Email__c = 'tmctesty@abc.com';
            c.Ocdla_Member_Status__c = 'A';
            c.MailingCity = 'Portland';
            c.MailingStateCode = 'OR';
            c.MailingPostalCode = '97209';
            c.MailingStreet = '1040 NW 10 AVE APT 219';
            
            return c;
        }
        else if('Event' == SObjectName){
            return new Event__c(Name='MyTestEvent');
        }
        else if('Standard PriceBook' == SObjectName){
            return new PriceBook2(Id=Test.getStandardPricebookId());
        }
        else if('PriceBook2' == SObjectName){
            return new PriceBook2();
        }
        else if('PriceBookEntry' == SObjectName){
            return new PriceBookEntry();
        }
        else return null;
    }
     
    public static void setup(){
       setup(random());
    }
    
    public static void setup(String recordPrefix){
        
        Ocdla_Apps__c orgDefaults = new Ocdla_Apps__c();
        orgDefaults.Ocdla_Test_Application_Server__c = 'membertest.ocdla.org';
        orgDefaults.Ocdla_Production_Application_Server__c = 'members.ocdla.org';
        orgDefaults.Ocdla_Force_Use_of_Test_Server__c = False;
        
		insert orgDefaults;


		Account a = (Account)ClickpdxTest.createSObject('Account');
        a.Name = OrgOcdla.GUEST_CHECKOUT_ACCOUNT_NAME;
        upsert a;        
        
		Account a1 = (Account)ClickpdxTest.createSObject('Account');
        a1.Name = recordPrefix;
        upsert a1;

        
        // Guest checkout account, inserted becuase it is referenced globally for Anonymous carts.
        Account guestCheckoutAccount = (Account)ClickpdxTest.createSObject('Account');
        guestCheckoutAccount.Id = OrgOcdla.GUEST_CHECKOUT_ACCOUNT_ID;
        upsert guestCheckoutAccount;
        
        
        
         
        
        Contact c = (Contact)ClickpdxTest.createSObject('Contact');
        c.AccountId = a1.Id;
        upsert c;
        
        Contact c2 = (Contact)ClickpdxTest.createSObject('Contact');
        c2.AccountId = guestCheckoutAccount.Id;
        upsert c2;
        
        Event__c evt = (Event__c)ClickpdxTest.createSObject('Event');
        evt.Name = recordPrefix + '_TEST EVENT';
        upsert evt;
        
        
        // This Product can be added to the cart.
        Product2 p = (Product2)ClickpdxTest.createSObject('Product2');
        p.Name = recordPrefix + '_TestProduct';
        p.Description = 'My Test Product';
        p.ProductCode = recordPrefix + '_TEST-ABC';
        p.IsActive = True;
        upsert p;
        
        // Event Tickets for Lawyer / Non-Lawyer
        Product2 ticketLawyer = (Product2)ClickpdxTest.createSObject('Product2');
        ticketLawyer.Name = recordPrefix + '_Lawyer Ticket';
        ticketLawyer.Description = evt.Name + 'Lawyer Ticket';
        ticketLawyer.ProductCode = recordPrefix + '-L';
        ticketLawyer.IsActive = True;
        upsert ticketLawyer;
        
        
        
        // Assign pricing info to the Product.
        PriceBook2 pb = (PriceBook2)ClickpdxTest.createSObject('Standard PriceBook');
        
        PriceBook2 nonMember = new PriceBook2();
        nonMember.Name = OrgOcdla.NON_MEMBER_PRICE_BOOK_NAME;
        nonMember.IsActive = True;
 		upsert nonMember;
        
        
        // Finalize a PriceBookEntries for any Products.
        List<PriceBookEntry> entries = new List<PriceBookEntry>();
        
        PriceBookEntry entry1 = (PriceBookEntry)ClickpdxTest.createSObject('PriceBookEntry');
        entry1.Pricebook2Id = pb.Id;
        entry1.Product2Id = p.Id;
        entry1.UnitPrice = 125.00;
        entry1.IsActive = True;
        // entry1.UseStandardPrice = True;

        PriceBookEntry entry2 = (PriceBookEntry)ClickpdxTest.createSObject('PriceBookEntry');
        entry2.Pricebook2Id = pb.Id;
        entry2.Product2Id = ticketLawyer.Id;
        entry2.UnitPrice = 125.00;
        entry2.IsActive = True;
        
        PriceBookEntry eb = (PriceBookEntry)ClickpdxTest.createSObject('PriceBookEntry');
        eb.Pricebook2Id = nonMember.Id;
        eb.Product2Id = ticketLawyer.Id;
        eb.UnitPrice = 125.00;
        eb.IsActive = True;

        
        entries.add(entry1);
        entries.add(entry2);
        upsert entries;
        upsert eb;
        
        // Insert some opportunities
        List<Opportunity> opps = new List<Opportunity>();
        Integer count = 0;
        while(count< 5) {
            Opportunity o = new Opportunity();
            o.Pricebook2Id = Test.getStandardPricebookId();
            o.AccountId = a.Id;
            o.Name = recordPrefix+'_Shopping Cart';
            o.StageName = 'Prospecting';
            o.CloseDate = System.today();
            opps.add(o);
            count++;
        }
        
        opps[0].AccountId = guestCheckoutAccount.Id;
        opps[1].AccountId = guestCheckoutAccount.Id;
        
        insert opps;
        
        
        // Add some Opportunity Products to the Opportunity.
        List<OpportunityLineItem> oli = new List<OpportunityLineItem>();
        count = 0;
        while(count< 5) {
            OpportunityLineItem ol = new OpportunityLineItem();
            ol.OpportunityId = opps[count].Id;
            ol.Product2Id = p.Id;
            ol.UnitPrice = 125.00;
            ol.Quantity = 1.0;
            oli.add(ol);
            count++;
        }
        
        insert oli;
        
        
        
        // Insert some test orders
        // Insert some opportunities
        List<Order> orders = new List<Order>();
        count = 0;
        while(count< 5) {
            Order o = new Order();
            o.Pricebook2Id = Test.getStandardPricebookId();
            o.AccountId = a.Id;
            o.EffectiveDate = System.today();
            o.Status = 'Attempted Payment';
            orders.add(o);
            count++;
        }
        
        insert orders;
        
        
        // Add some Opportunity Products to the Opportunity.
        List<OrderItem> orderLines = new List<OrderItem>();
        count = 0;
        while(count< 5) {
            OrderItem ol = new OrderItem();
            ol.OrderId = orders[count].Id;
            ol.Product2Id = p.Id;
            ol.UnitPrice = 125.00;
            ol.Quantity = 1.0;
            ol.Description = 'Some line description';
            ol.PricebookEntryId = entry1.Id;
            orderLines.add(ol);
            count++;
        }
        
        insert orderLines;
        
        
    }
    
    
    


    
    public static User getSystemUser(){
        // Now insert a System user
        Profile p = [SELECT Id,Name FROM Profile WHERE Name=:SYSTEM_USER_PROFILE_NAME]; 
        // System.assertEquals(UserInfo.getProfileId(),p.Id);
        System.assertEquals(p.Name,SYSTEM_USER_PROFILE_NAME);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        User systemUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                   EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                   LocaleSidKey='en_US', ProfileId = p.Id, 
                                   UserRoleId = portalRole.Id,
                                   TimeZoneSidKey='America/Los_Angeles', UserName='abcxstandarduser@testorg.com');
        
        return systemUser;
    }
    
   
    
    

    
    public static EmailTemplate createEmailTemplate(String templateName){
        EmailTemplate t;

        
        t = new EmailTemplate();
        t.isActive = true;
        t.Name = templateName;
        t.DeveloperName = templateName.replaceAll('[\\s]','_');
        t.TemplateType = 'text';
        t.FolderId = UserInfo.getUserId();
        
        return t;
    }    
    
    public static String random(){
        Integer len = 10;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,len);
    }

    
    
}