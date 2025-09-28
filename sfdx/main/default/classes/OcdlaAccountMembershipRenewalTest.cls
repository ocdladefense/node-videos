@isTest
public class OcdlaAccountMembershipRenewalTest {
      
    private static String recordPrefix = 'TEST003';
     
    private static String MEMBER_STATUS_LAW_STUDENT_MEMBERSHIP = 'A';
    
    private static String MEMBER_STATUS_REGULAR_MEMBERSHIP = 'R';
    
    public Account a; 
    
    // Member with some future expiration.
    public Contact c;
    
    // Member that has already renewed.
    public Contact c2;
    
    public Product2 p;
    
    public Product2 p2;
    
    public PricebookEntry entry;
    
    public PricebookEntry entry2;
     
    public OcdlaAccountMembershipRenewalTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        
		Ocdla_Apps__c orgSettings = new Ocdla_Apps__c();
        orgSettings.Ocdla_Current_Membership_Term_End_Date__c = System.today();
        insert orgSettings;
        
        this.p = [SELECT Id, Name, Family, Description FROM Product2 LIMIT 1];
        this.p.OcdlaMembershipStatusGrant__c = MEMBER_STATUS_REGULAR_MEMBERSHIP;
        this.p.Family = OcdlaAccountMembershipRenewal.MEMBERSHIP_PRODUCT_FAMILY;
        upsert this.p;
        
        this.p2 = this.p.clone();
        this.p2.Name = 'Already Renewed';
        upsert this.p2;
        
        this.entry = [SELECT Id,UnitPrice,Pricebook2Id,IsActive,Product2Id FROM PricebookEntry WHERE Product2Id = :this.p.Id];
        this.entry.IsActive = True;
        upsert this.entry;
        
        this.entry2 = this.entry.clone();
        this.entry2.Product2Id = this.p2.Id;
        upsert this.entry2;
        
        System.assertEquals(this.entry.Product2Id, this.p.Id, 'The Product does not match the referenced Pricebook Entry.');
        
        this.a = [SELECT Id, Name, OrderApi__Primary_Contact__c FROM Account LIMIT 1];
        
        this.c = [SELECT Id, FirstName, LastName, Ocdla_Current_Member_Flag__c, AccountId, Email FROM Contact WHERE Name LIKE :filter LIMIT 1];
        this.c.AccountId = this.a.Id;
        this.c.Ocdla_Member_Status__c = 'R';
        this.c.Ocdla_Membership_Expiration_Date__c = System.today().addYears(1);
        upsert this.c;
        
        this.c2 = this.c.clone();
        this.c2.Ocdla_Membership_Expiration_Date__c = OcdlaAccountMembershipRenewal.MEMBERSHIP_RENEWAL_DATE;
        upsert this.c2;
        
          
        this.a.OrderApi__Primary_Contact__c = c.Id;
        upsert a;
        
        this.c = [SELECT Id, FirstName, LastName, Ocdla_Current_Member_Flag__c, AccountId, Email FROM Contact WHERE Id = :this.c.Id];
        
        System.assertEquals(True,this.c.Ocdla_Current_Member_Flag__c, 'The Contact should be considered a Current Member but is not.');
    }
      
     
    @testSetup static void setup() {
        testSetup();
    } 
     
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxCore.TestBase.setup(recordPrefix);        
    }


    
    static testMethod void accountMembershipRenewalEmailNotificationTest(){

		OcdlaAccountMembershipRenewalTest context = new OcdlaAccountMembershipRenewalTest();
        ClickpdxShoppingCart pdCart;
        Opportunity cartOpportunity;
         
        test.startTest();
        

		cartOpportunity = OcdlaAccountMembershipRenewal.createAccountMembershipRenewal(context.a.Id);

        Id whoId = context.c.Id;
        System.assert(whoId != null);
        
        Id whatId = cartOpportunity.Id;
        System.assert(whatId != null);
        
        String templateName = 'OCDLA Paid Office Renewal';

		OcdlaAccountMembershipRenewalEmails.previewPaidOfficeRenewalNotificationEmail(templateName,context.a.Id);        

		OcdlaAccountMembershipRenewalEmails.testPaidOfficeRenewalNotificationEmail(templateName,context.a.Id);
        
		OcdlaAccountMembershipRenewalEmails.sendPaidOfficeRenewalNotificationEmail(templateName,context.a.Id);
        
        test.stopTest();
    }
      
    
    testMethod static void testMembershipProducts(){
        // Verify that some Products are configured with  
        // relevant membership statuses.
        
        PricebookEntry relatedMembershipEntry;
        
		OcdlaAccountMembershipRenewalTest context = new OcdlaAccountMembershipRenewalTest();
        
        // There should be at least one membership product.
        OcdlaAccountMembershipRenewal.initMembershipEntries();
        
        System.assertNotEquals(null, OcdlaAccountMembershipRenewal.membershipEntries, 'There were no membership entries but there should be at least one entry for the "R" membership.');
        
        relatedMembershipEntry = OcdlaAccountMembershipRenewal.getPricebookEntriesByMembershipStatus(MEMBER_STATUS_REGULAR_MEMBERSHIP);

    }
     
    testMethod static void lookupMembershipProduct(){
        PricebookEntry relatedMembershipEntry;
        
		OcdlaAccountMembershipRenewalTest context = new OcdlaAccountMembershipRenewalTest();
        OcdlaAccountMembershipRenewal.lookupAlreadyRenewed();
        relatedMembershipEntry = OcdlaAccountMembershipRenewal.lookupMembershipProduct('R',2018);
    }
    
    
    
    testMethod static void createMembershipRenewalShoppingCart(){
        OcdlaAccountMembershipRenewalTest context = new OcdlaAccountMembershipRenewalTest();
        Opportunity cartOpportunity;
        PricebookEntry membershipPrice;
        
        Test.startTest();

        cartOpportunity = OcdlaAccountMembershipRenewal.createAccountMembershipRenewal(context.a.Id);
		
        membershipPrice = OcdlaAccountMembershipRenewal.getPricebookEntriesByMembershipStatus('R');
        
        if(null == membershipPrice){
            membershipPrice = context.entry;
        }

        Test.stopTest();
    }

    
    
    
    
    
    
}