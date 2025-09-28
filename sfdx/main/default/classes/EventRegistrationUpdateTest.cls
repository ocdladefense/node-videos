@isTest
public class EventRegistrationUpdateTest {

    
    private static String recordPrefix = 'TEST001';
    
    public Event__c evt;
    
    public Account a;
     
    public Product2 p;
    
    public Contact c;
    
    public Order o;
    
    public List<OrderItem> lines;
    
    
     
    public EventRegistrationUpdateTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];
        
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
        
        
        List<PriceBookEntry> entries = [SELECT Id, Name, Discounts__c FROM PricebookEntry];
        entries[0].Discounts__c = jSerial;
        entries[1].Discounts__c = jSerial;
        update entries[0];
        update entries[1];
        
        this.p.Event__c = this.evt.Id;
        upsert this.p; 

        this.o = [SELECT Id, OrderNumber, OpportunityId FROM Order LIMIT 1];
        
        this.lines = [SELECT Id, OrderId, PricebookEntryId, Description, UnitPrice, TotalPrice, Quantity, Contact__c,
                      FirstName__c, LastName__c FROM OrderItem WHERE OrderId = :this.o.Id];
    }
      
     
    @testSetup static void setup() {
        testSetup();
    } 
     
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
		ClickpdxTest.setup(recordPrefix);        
    }

    
    testMethod static void loadEventUpdatePage(){
        EventRegistrationUpdateTest context = new EventRegistrationUpdateTest();
        
        Test.startTest();
        
        PageReference thePage = Page.EventRegistrationUpdate;

        
        Test.setCurrentPage(thePage);
        thePage.getParameters().put('lineId',context.lines[0].Id);
        EventRegistrationUpdate controller = new EventRegistrationUpdate(context.lines[0].Id);  
		controller = new EventRegistrationUpdate();

        Test.stopTest();
    }
    
    
    testMethod static void updateJson(){
        EventRegistrationUpdateTest context = new EventRegistrationUpdateTest();
        
        Test.startTest();
        
        PageReference thePage = Page.EventRegistrationUpdate;

        
        Test.setCurrentPage(thePage);
        thePage.getParameters().put('lineId',context.lines[0].Id);
        EventRegistrationUpdate controller = new EventRegistrationUpdate(context.lines[0].Id);  

        
        String myJson = '{"meal":"steak","breakout":"abuse"}';
        String lineId = controller.lineId;
        String lineData = controller.lineData;
        
        EventRegistrationUpdate.isEmptyJson(myJson);
        EventRegistrationUpdate.doUpdate(myJson,null);

        Test.stopTest();
    }
    
}