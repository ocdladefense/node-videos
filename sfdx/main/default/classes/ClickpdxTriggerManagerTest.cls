@isTest
public class ClickpdxTriggerManagerTest {
    
    private static String recordPrefix = 'TEST001';
    
    public Event__c evt;
    
    public Account a;
    
    public Product2 p;
    
    public Contact c;
    
    
     
    public ClickpdxTriggerManagerTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, MailingAddress, MailingStreet, MailingCity, MailingState,
                  MailingStateCode, MailingPostalCode, MailingCountryCode, Email FROM Contact LIMIT 1];
        
        this.p = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        this.p.OcdlaEligibleMemberStatuses__c = 'R,N,A,S,L,T,LL';
        update this.p;
        
        this.evt = [SELECT Id, Name, Start_Date__c, Include_In_Catalog__c FROM Event__c WHERE Name LIKE :filter LIMIT 1];
        this.evt.Early_Bird_End_Date__c = System.today()+10;
        this.evt.Start_Date__c = System.today();
        this.evt.Include_In_Catalog__c = True;
        upsert this.evt;
        
        
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
        
        this.p.Event__c = this.evt.Id;
        upsert this.p; 
        
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }
    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
		ClickpdxTest.setup(recordPrefix);        
    }

     
    
    /**
     * 
     * @method, loadTriggerManager
     * 
     * @description, The Trigger Manager is used to recall individual ClickpdxTrigger instances.
     * 
     * @test, This test method initializes the Trigger Manager with at least one ClickpdxTrigger instance;
     * 
     */
	@isTest
    static void loadTriggerManager() {
        System.assertNotEquals(null, recordPrefix, 'The record prefix for this test execution is null.');

        // Variable initialization.
		ClickpdxTriggerManagerTest context = new ClickpdxTriggerManagerTest();
        
        Test.startTest();
       		ClickpdxTriggerManager.ClickpdxTrigger t = ClickpdxTriggerManager.getTrigger('Contact.mailingAddressToRelatedAddress');
            OcdlaContacts.syncToRelatedAddresses(new List<Contact>{context.c},t);
        Test.stopTest();
    } 
    
    
    /**
     * 
     * @method, loadTriggerManager
     * 
     * @description, The Trigger Manager is used to recall individual ClickpdxTrigger instances.
     * 
     * @test, This test method initializes the Trigger Manager with at least one ClickpdxTrigger instance;
     * 
     */
	@isTest
    static void execContactToRelatedAddressTrigger() {
        System.assertNotEquals(null, recordPrefix, 'The record prefix for this test execution is null.');

        // Variable initialization.
		ClickpdxTriggerManagerTest context = new ClickpdxTriggerManagerTest();
        
        Test.startTest();
       		ClickpdxTriggerManager.ClickpdxTrigger t = ClickpdxTriggerManager.getTrigger('Contact.mailingAddressToRelatedAddress');
            Contact c = context.c;
        	c.FirstName = 'Mr. Test';
        	update c;
        Test.stopTest();
    }
    
}