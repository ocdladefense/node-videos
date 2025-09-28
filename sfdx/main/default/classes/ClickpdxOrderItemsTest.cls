@isTest
public class ClickpdxOrderItemsTest {
      
    private static String recordPrefix = 'TEST004';
    
    public Event__c evt;   
    
    public Account a;
    
    public Product2 p;   
     
    public Order o;
    
    public Event__c e;
    
    List<OrderItem> lines; 
    
    public PricebookEntry entry;
    
    public OrderItem theLine;
    
     
     
    public ClickpdxOrderItemsTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        
        Contact c = [SELECT Id FROM Contact LIMIT 1];
        
        this.p = [SELECT Id, Name, ProductCode, GrantField__c, GrantValue__c FROM Product2 WHERE Name LIKE :filter LIMIT 1];
		this.p.GrantField__c = 'Note_1__c';
        this.p.GrantValue__c = 'HC';
        upsert this.p;
        
        List<PricebookEntry> entries = [SELECT Id FROM PricebookEntry WHERE Product2Id = :this.p.Id];
		entry = entries[0];
        
        this.o = [SELECT Id, OrderNumber, OpportunityId FROM Order LIMIT 1];
        
        this.e = [SELECT Id FROM Event__c LIMIT 1];
        this.p.Event__c = e.Id;
		upsert p;

        
        this.lines = [SELECT Id, Description, PricebookEntryId, ParentLineId__c, UnitPrice, TotalPrice, Quantity, Contact__c,
                      FirstName__c, LastName__c FROM OrderItem WHERE OrderId = :this.o.Id];
       	
        theLine = new OrderItem(PricebookEntryId = entries[0].Id,UnitPrice = 45.00,Quantity=1.0);
        theLine.OrderId = this.o.Id;
        theLine.ParentLineId__c = this.lines[0].Id;
        theLine.Contact__c = c.Id;
        insert theLine;
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }
    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxTest.setup(recordPrefix);        
    }
    

	@isTest 
    static void testProductGrants(){
		ClickpdxOrderItemsTest context = new ClickpdxOrderItemsTest();
        context.p.GrantField__c = 'Contact__r.OcdlaCapitalDefendersExpiration__c';
        context.p.GrantValue__c = 'TODAY()';
        update context.p;
 
        List<OrderItem> triggerNew = new List<OrderItem>{context.theLine};        
		
        ClickpdxOrderItems.evaluateOrderItemProductGrantsOnLinesRevised(triggerNew);
    } 
    
    @isTest
    static void loadOrderItems() {
		ClickpdxOrderItemsTest context = new ClickpdxOrderItemsTest();

         
        Test.startTest();
		
        PageReference viewing = Page.ClickpdxOrderItems;
        viewing.getParameters().put('eventId',context.e.Id);
        Test.setCurrentPage(viewing);
        
        ClickpdxOrderItems listToView = new ClickpdxOrderItems();

        Test.stopTest();
    }
    
    
    @isTest
    static void loadAllOrderItems() {
		ClickpdxOrderItemsTest context = new ClickpdxOrderItemsTest();

         
        Test.startTest();
		
        PageReference viewing = Page.ClickpdxOrderItems;
        Test.setCurrentPage(viewing);
        
        ClickpdxOrderItems listToView = new ClickpdxOrderItems();

        Test.stopTest();
    }
     
    @isTest
    static void testTicketTypes(){
		ClickpdxOrderItemsTest context = new ClickpdxOrderItemsTest();

         
        Test.startTest();
		
        PageReference viewing = Page.ClickpdxOrderItems;
        viewing.getParameters().put('eventId',context.e.Id);
        Test.setCurrentPage(viewing);
        
        ClickpdxOrderItems listToView = new ClickpdxOrderItems();
        List<Product2> ticketTypes = listToView.getTicketTypes();

        Test.stopTest();
    }
    
    @isTest
    static void testFilterByProductId(){
		ClickpdxOrderItemsTest context = new ClickpdxOrderItemsTest();

         
        Test.startTest();
		
        PageReference viewing = Page.ClickpdxOrderItems;
        viewing.getParameters().put('eventId',context.e.Id);
        viewing.getParameters().put('product2Id',context.p.Id);
        Test.setCurrentPage(viewing);
        
        ClickpdxOrderItems listToView = new ClickpdxOrderItems();
        List<Product2> ticketTypes = listToView.getTicketTypes();

        Test.stopTest();
    }
    
    
    @isTest
    static void loadMembershipLists() {
		ClickpdxOrderItemsTest context = new ClickpdxOrderItemsTest();

         
        Test.startTest();
		
        PageReference viewing = Page.OcdlaMemberships;
        viewing.getParameters().put('listId',context.e.Id);
        Test.setCurrentPage(viewing);
        
        OcdlaMemberships listToView = new OcdlaMemberships();
		listToView.getLists();
        Test.stopTest();
    }

    

    
    
}