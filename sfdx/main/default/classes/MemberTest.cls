@IsTest
public class MemberTest {
    
    private static String recordPrefix = 'TEST003'; 
    
    public Account a;    
        
    public Contact c;      
      
    public Product2 p;
      
    public PricebookEntry entry;
    
    public List<OrderItem> lines;

    
    static final Integer CURRENT_MEMBERSHIP_YEAR_2024 = 2024;
    
    static final Integer PREVIOUS_MEMBERSHIP_YEAR_2023 = 2023;
    
    // For the membership period ending 6/30/2024
    // the membership would likely have been purchased in 2023.
    static final Integer CURRENT_MEMBERSHIP_PURCHASED_IN_2023 = 2023;
    
    // Assume a previous membership period say ending 6/30/2023.
    // That membership would likely have been purchased in 2022.
    static final Integer PREVIOUS_MEMBERSHIP_PURCHASED_IN_2022 = 2022;
     
    
    
    public MemberTest() {
        
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';

       	a = new Account(Name='OCDLA');
        insert a;
        
        // Let's create a new member; include their expiration date.
        Integer currentMembershipYear = 2024;
        c = new Contact(FirstName='José',LastName='Bernal',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        c.Ocdla_Membership_Expiration_Date__c = Date.newInstance(CURRENT_MEMBERSHIP_YEAR_2024,6,30);
        insert c;
          
        
        this.p = [SELECT Id, Name, Event__c, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        this.p.ConfirmationEmailSubject__c = '{!Contact.FirstName}';
        this.p.ConfirmationEmailBody__c = '{!OrderItem.FirstName__c}';
        this.p.Family = 'Memberships';
        update this.p;

        
        this.entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :this.p.Id];
        
        
        // Let's create a membership history for the contact.
        // Let's assume they purchased a membership for this year.
        // and also one for the previous year.
        Date currentMembershipPurchaseDate = Date.newInstance(CURRENT_MEMBERSHIP_PURCHASED_IN_2023,4,1);
        Date previousMembershipPurchaseDate = Date.newInstance(PREVIOUS_MEMBERSHIP_PURCHASED_IN_2022,4,1);
        
        
        Order o1 = new Order(AccountId=a.Id,Status='Draft',EffectiveDate=currentMembershipPurchaseDate);
        o1.Pricebook2Id = ClickpdxCore.Application.config.getStdPricebookId();
        insert o1;
        
        
		Order o2 = new Order(AccountId=a.Id,Status='Draft',EffectiveDate=previousMembershipPurchaseDate);
        o2.Pricebook2Id = ClickpdxCore.Application.config.getStdPricebookId();
        insert o2;
         

         
        
        OrderItem line1 = new OrderItem(PricebookEntryId=entry.Id,UnitPrice=1.00,Quantity=1.00,Contact__c=c.Id,FirstName__c='Jane',LastName__c='Doe');
        line1.OrderId = o1.Id;
        insert line1;
        
        OrderItem line2 = new OrderItem(PricebookEntryId=entry.Id,UnitPrice=1.00,Quantity=1.00,Contact__c=c.Id,FirstName__c='Jane',LastName__c='Doe');
        line2.OrderId = o2.Id;
        insert line2;
    }
        
     
    @testSetup
    static void setup() {
        testSetup();
    }    
       
    public static void testSetup() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxCore.TestBase.setup(recordPrefix);        
    }
    
    
    /**
     * Our test contact is a current member with a 6/30/2024 expiration date.  Their
     * membership was purchased 4/1/2023.
     * They also have a previous membership for the membership period ending 6/30/2023.
     * That membership was purchased 4/1/2022.
     * Here we want to test that Member.hasMembershipsPriorTo() return True for our member.
     */
    @isTest
    private static void testHasPreviousMembership() {
        MemberTest context = new MemberTest();
        
        Id contactId = context.c.Id;
        
        // Our member has one membership purchase prior to the 2024 membership year.
        Boolean hasPriorTo2024 = Member.hasMembershipsPriorTo(contactId, CURRENT_MEMBERSHIP_YEAR_2024);
        System.assert(hasPriorTo2024);
        
        // But no memberships prior to the 2023 membership year.
        Boolean hasPriorTo2023 = Member.hasMembershipsPriorTo(contactId, PREVIOUS_MEMBERSHIP_YEAR_2023);
        System.assert(!hasPriorTo2023);
    }
    
    
    /**
     * Get all membership purchases for the given member.
     */
    @isTest
    private static void testGetMemberships() {
        
        MemberTest context = new MemberTest();
        
        Id contactId = context.c.Id;
        
       	List<OrderItem> purchases = Member.getMemberships(contactId);
        
        // Our test member should have two memberships.
        System.assert(purchases.size() == 2);
    }
    
    
    /**
     * Get all membership purchases for the given member.
     */
    @isTest
    private static void testIsNewMember() {
        
        MemberTest context = new MemberTest();
        
        Id contactId = context.c.Id;
        
       	Boolean isNew = Member.isNewMember(contactId, 2024);
        
        System.assert(!isNew);
    }
    
    
    
    /**
     * Get all membership purchases for the given member.
     */
    @isTest
    private static void testhasMembershipsPriorTo() {
        
        MemberTest context = new MemberTest();
        
        Id contactId = context.c.Id;
        
       	Map<Id,Boolean> foobar = Member.hasMembershipsPriorTo(new List<Id>{contactId}, 2024);
        
        // System.assert(!isNew);
    }
    
}