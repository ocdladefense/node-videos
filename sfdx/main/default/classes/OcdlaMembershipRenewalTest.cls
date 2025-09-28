@isTest
public class OcdlaMembershipRenewalTest {
    
    private static String recordPrefix = 'TEST001';
    
    public Opportunity opp; 
    
    public Account a; 
    
    public Product2 p;
     
	private static String MEMBER_STATUS_REGULAR_MEMBERSHIP    = 'R';
    
    public OcdlaMembershipRenewalTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        
        this.p = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        this.p.OcdlaMembershipStatusGrant__c = MEMBER_STATUS_REGULAR_MEMBERSHIP;
        this.p.Family = OcdlaAccountMembershipRenewal.MEMBERSHIP_PRODUCT_FAMILY;
        upsert this.p;
        
        
        this.opp = [SELECT Id, Name FROM Opportunity WHERE Name LIKE :filter LIMIT 1];
        
        // this.evt = [SELECT Id, Name FROM Event__c WHERE Name LIKE :filter LIMIT 1];
        // this.evt.Early_Bird_End_Date__c = System.today()+10;
        // upsert this.evt;
        
        
        ClickpdxPriceRule eb = new ClickpdxPriceRule();
        eb.name = 'Early Bird';
        eb.active = True;
        eb.attribute = 'Member Status';
        eb.attributeType = 'System.Date';
        eb.value = '2017-12-25';
        eb.op = '<=';
        eb.price = 75.25;
        
        String jSerial = JSON.serialize(eb);
        
        
        List<PriceBookEntry> entries = [SELECT Id, Name, Discounts__c FROM PriceBookEntry];
        entries[0].Discounts__c = jSerial;
        entries[1].Discounts__c = jSerial;
        update entries[0];
        update entries[1];
        
        // this.p.Event__c = this.evt.Id;
        upsert this.p; 
        
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }
    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxTest.setup(recordPrefix);        
    }
    
    
    @isTest(SeeAllData=false)
    static void loadEventPageAsGuestUser() {
        System.assertNotEquals(null, recordPrefix, 'The record prefix for this test execution is null.');
        
        // Variable initialization.
        OcdlaMembershipRenewalTest context = new OcdlaMembershipRenewalTest();
         
        
        User guest = ClickpdxTest.getStaticGuestUser();
        
        Test.startTest();
        
        
        
        System.runAs(guest) {
            
            PageReference evtPage = Page.OcdlaOfficeMembershipRenewal;
            evtPage.getParameters().put('id', context.opp.Id);
            Test.setCurrentPage(evtPage);      
            OcdlaOfficeMembershipRenewalController evtCtrl = new OcdlaOfficeMembershipRenewalController();
            evtCtrl.getDynamicShoppingCart();
            
            
        }
        
        Test.stopTest();
    }
    
    static testMethod void loadEventPage() {
        // Variable initialization.
        OcdlaMembershipRenewalTest context = new OcdlaMembershipRenewalTest();
        
        
        Test.startTest();
        
        
        
        PageReference evtPage = Page.OcdlaOfficeMembershipRenewal;
        evtPage.getParameters().put('id', context.opp.Id);
        Test.setCurrentPage(evtPage);
        
        OcdlaOfficeMembershipRenewalController evtCtrl = new OcdlaOfficeMembershipRenewalController();
        
        evtCtrl.loadOpportunity();
        evtCtrl.getPageTemplate();
        
        
        
        
        Test.stopTest();
    }
    
    
    

    
    
    static testMethod void initEventRegistrationController() {
        // Variable initialization.
        OcdlaMembershipRenewalTest context = new OcdlaMembershipRenewalTest();
        
        
        Test.startTest();
        
        ClickpdxPriceRule eb = new ClickpdxPriceRule();
        eb.name = 'Early Bird';
        eb.active = True;
        eb.attribute = 'Member Status';
        eb.attributeType = 'System.Date';
        eb.value = '2017-12-25';
        eb.op = '<=';
        eb.price = 75.25;
        
        
        
         
        PageReference evtPage = Page.OcdlaOfficeMembershipRenewal;
        evtPage.getParameters().put('id', context.opp.Id);
        
        Test.setCurrentPage(evtPage);
        
        OcdlaOfficeMembershipRenewalController evtCtrl = new OcdlaOfficeMembershipRenewalController();        
        
        OcdlaPaidOfficeComponentController c = new OcdlaPaidOfficeComponentController();
        c.oppId = context.opp.Id;
        c.getAvailableTicketsJson();
        
        List<ClickpdxCartItem> registrants = c.getRegistrants();
        
        c.getRegistrationListOptions();
        
        OcdlaPaidOfficeComponentController.formatDate(System.today());
        
        c.getAvailableTickets();
        
        c.availableAddOns();
        
        c.getHasRegistrants();
        
        Test.stopTest();
    }
    
}