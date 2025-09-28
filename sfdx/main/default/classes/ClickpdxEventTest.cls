@isTest
public class ClickpdxEventTest {  
     
    private static String recordPrefix = 'TEST001';
    
    public Event__c evt; 
    
    public Event__c evt2; 
    
    public Account a; 
      
    public Product2 p;
    
    public Contact c;
    
     
     
    public ClickpdxEventTest() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];
        
        this.p = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        this.p.OcdlaEligibleMemberStatuses__c = 'R,N,A,S,L,T,LL';
        update this.p;
        
        this.evt = Database.query(ClickpdxEventList.query + ' WHERE Name LIKE :filter LIMIT 1');
        this.evt.Early_Bird_End_Date__c = System.today()+10;
        this.evt.Start_Date__c = System.today();
        this.evt.Include_In_Catalog__c = True;
        upsert this.evt;
        
        this.evt2 = this.evt.clone();
        upsert this.evt2;
        
         
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
        this.p.Event__c = this.evt.Id;
        
        update entries[0];
        update entries[1];
        upsert this.p; 
    }
    

	@isTest
    private static void testBatchEventReg() {
        // Variable initialization.
		ClickpdxEventTest context = new ClickpdxEventTest();

        
        Test.startTest();
        
        
        ClickpdxOrder.createPaidOfficeEventOrder(context.evt.Id,context.a.Id);
        
        Test.stopTest();
    }


    
    @testSetup
    private static void setup() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
		ClickpdxTest.setup(recordPrefix);   
    }
    
    

    
	@isTest(SeeAllData=false)
    private static void loadEventPageAsGuestUser() {
        System.assertNotEquals(null, recordPrefix, 'The record prefix for this test execution is null.');

        // Variable initialization.
		ClickpdxEventTest context = new ClickpdxEventTest();
        
        Test.startTest();

            
            PageReference evtPage = Page.OcdlaEvent;
            evtPage.getParameters().put('id', context.evt.Id);
            Test.setCurrentPage(evtPage);      
            ClickpdxEventControllerExtension evtCtrl = new ClickpdxEventControllerExtension();


        Test.stopTest();
    }
  
    
    @isTest
    private static void loadEventPage() {
        // Variable initialization.
		ClickpdxEventTest context = new ClickpdxEventTest();

         
        Test.startTest(); 

        PageReference evtPage = Page.OcdlaEvent;
        evtPage.getParameters().put('id', context.evt.Id);
        Test.setCurrentPage(evtPage);
    
        ClickpdxEventControllerExtension con = new ClickpdxEventControllerExtension();
        
        con.loadEvent();
        con.getOverview();
        con.getAgenda();
        con.getSecondaryAgenda();
        con.getVenue();
        con.getComponent('foobar');


        Test.stopTest();
    }

 
    @isTest
    private static void createBatchEventRegOrder() {
		ClickpdxEventTest context = new ClickpdxEventTest();
        
        // ClickpdxOrder.createPaidOfficeEventOrder(context.evt.Id,context.a.Id);
    }
       
    
    @isTest
    private static void loadEventManager() {
        // Variable initialization.
		ClickpdxEventTest context = new ClickpdxEventTest();

         
        Test.startTest(); 

        PageReference evtPage = Page.EventManager;
        evtPage.getParameters().put('contactId', context.c.Id);
        evtPage.getParameters().put('id',context.evt.Id); 
        Test.setCurrentPage(evtPage);
    
        EventManagerController evtCtrl = new EventManagerController();
        // evtCtrl.getAvailableEventsJson();
        // evtCtrl.getMorrowRegistrationData();
        
        
        Order o = new Order(AccountId=context.a.Id,Status='Draft',EffectiveDate=System.today());
        o.Pricebook2Id = ClickpdxCore.Application.config.getStdPricebookId();
        insert o;
        
        
		Registration__c reg = new Registration__c(Order__c=o.Id,FirstName__c='Testy',LastName__c='McTester',Meal__c='salmon');
        insert reg;
        
		EventManagerController.OrderItemUpdateStatus[] foobar = EventManagerController.saveOrderLineData(reg);


        Test.stopTest();
    }
    
    
    @isTest
    private static void loadEventListPage() {
        // Variable initialization.
		ClickpdxEventTest context = new ClickpdxEventTest();

        
        Test.startTest();  


            ClickpdxEventList ctrl = new ClickpdxEventList();
        
        	// System.assert(ctrl.theEvents != null && ctrl.theEvents.size() > 1);
            PageReference evtPage = Page.OcdlaEvents;
            Test.setCurrentPage(evtPage);

        // ctrl.getTheEvents();
        
		ClickpdxEvent evt1 = new ClickpdxEvent(context.evt);
		ClickpdxEvent evt2 = new ClickpdxEvent(context.evt2);
        
        EventListKey k1 = new EventListKey(evt1);
        EventListKey k2 = new EventListKey(evt2);
        
        k1.compareTo(k2);
        k1.hashCode();
        
        
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void initEventRegistrationController() {
        // Variable initialization.
		ClickpdxEventTest context = new ClickpdxEventTest();

        
        Test.startTest();
        
        ClickpdxPriceRule eb = new ClickpdxPriceRule();
        eb.name = 'Early Bird';
        eb.active = True;
        eb.attribute = 'Member Status';
        eb.attributeType = 'System.Date';
        eb.value = '2017-12-25';
        eb.op = '<=';
        eb.price = 75.25;
        


            
        	PageReference evtPage = Page.OcdlaEvent;
            evtPage.getParameters().put('id', context.evt.Id);
            
        	Test.setCurrentPage(evtPage);

        		ClickpdxEventControllerExtension evtCtrl = new ClickpdxEventControllerExtension();        
        	ClickpdxEventRegistrationController c = new ClickpdxEventRegistrationController();
        	c.eventId = context.evt.Id;
        	c.getAvailableTicketsJson();
        
        	Map<String,ClickpdxCartItem> registrants = c.getRegistrants();

        	c.getRegistrationListOptions();
        
        	ClickpdxEventRegistrationController.formatDate(System.today());
        
        	c.getAvailableTickets();
        
        	c.availableAddOns();
        
        	c.getHasRegistrants();
        
        	c.getRegistrantsFromOpportunityAction();
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void testCreateOrderItemFromEvent() {
        
    }
    
    @isTest
    private static void createEarlyBirdPriceRule() {
        // Variable initialization.
        ClickpdxEventTest context = new ClickpdxEventTest();
        
        
        Test.startTest();   
        
		ClickpdxPriceRule rule = OcdlaEvent.createPriceRuleObject(125.00, System.today());
            
		Test.stopTest();
    }   
}