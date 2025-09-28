@isTest
private class RegistrationTest {
  
      
    private static User u; 
    
    private static Profile theProfile;
    
    private static sObject settings;
    
    private static EmailTemplate validEmailTemplate;
    
    private static Account testAccount; 
    
    private static Contact theCustomer;
    
    private static String recordPrefix = 'TEST004';
    
    public Event__c evt;
    
    public Account a;
    
    public Contact c;
    
    public Product2 p; 
    
    public Order o;
    
    public Event__c e;
    
    List<OrderItem> lines;
    
    public PricebookEntry entry;
    
    
    
    public RegistrationTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        
        this.c = [SELECT Id, Name FROM Contact LIMIT 1];
        
        this.p = [SELECT Id, Name, Event__c, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        
        this.o = [SELECT Id, OrderNumber, OpportunityId FROM Order LIMIT 1];
        
        this.e = [SELECT Id FROM Event__c LIMIT 1];
        this.e.EventConfirmationEmail__c = '{!OrderItem.FirstName__c}';
        this.e.EventConfirmationEmailSubject__c = 'OCDLA Annual Conference - June 14–16, 2018, Bend';//{!Contact.FirstName}';
        update this.e;
        
        this.p.Event__c = this.e.Id;
        update this.p;
        
        this.entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :this.p.Id LIMIT 1];
        
        this.lines = [SELECT Id, OrderId, PricebookEntryId, Description, UnitPrice, TotalPrice, Quantity, Contact__c,
                      FirstName__c, LastName__c, Data__c FROM OrderItem WHERE OrderId = :this.o.Id];
        this.lines[0].Data__c = JSON.serialize(new List<Map<String,String>>{new Map<String,String>{'firstName'=>'Testy','lastName'=>'McTester','meal'=>'steak'}});
        update this.lines[0];
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }

    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxTest.setup(recordPrefix);        
    }
     
    
    private static testMethod void createRegistrations(){
        RegistrationTest context = new RegistrationTest();
        Order theOrder;
        
        ClickpdxShoppingCart clickpdxCart = new ClickpdxShoppingCart(context.a);
        
        Test.startTest();
        

        JsonData data = new JsonData(context.lines[0].Data__c);
        Map<String,String> regData = data.getDefault();
        data = new JsonData();
        
        if(!Registration.hasRegistrations(new List<Id>{context.o.Id})){
            Registration.createRegistrations(new List<Id>{context.o.Id}, context.e.Id);
        }
        Registration.isEmpty('');
        Order o = new Order(AccountId=context.a.Id,Status='Draft',EffectiveDate=System.today());
        o.Pricebook2Id = ClickpdxCore.Application.config.getStdPricebookId();
        insert o;
        
        Registration.hasRegistrations(o.Id);
        
        OrderItem line = new OrderItem(OrderId=o.Id,PricebookEntryId=context.entry.Id,Quantity=1.0);
        
        
		Registration__c reg = new Registration__c(OrderProduct__c=line.Id,Order__c=o.Id,FirstName__c='Testy',
                                                  LastName__c='McTester',Meal__c='beef');
        insert reg;
        
        Registration.getWhoIds(new List<Id>{reg.Id});
        Registration.addSeats(new List<Id>{reg.Id});
        
        // New call here:
        Registration.sendProductConfirmEmail(new List<Id>{reg.Id});
        
        Test.stopTest();
    }


    private static testMethod void processRegistrationOrder(){
        RegistrationTest context = new RegistrationTest();
        Order o;
        OrderItem line;
        List<Registration__c> regs;
        ClickpdxShoppingCart clickpdxCart = new ClickpdxShoppingCart(context.a);
        
        context.p.AllowedRegistrations__c = 1.0;
        context.p.Event__c = context.e.Id;
        update context.p;
        
        System.assert(context.p.Event__c == context.e.Id);
        
        Test.startTest();
            
            o = new Order(AccountId=context.a.Id,Status='Draft',EffectiveDate=System.today());
            o.Pricebook2Id = ClickpdxCore.Application.config.getStdPricebookId();
            insert o;
            
            line = new OrderItem(OrderId=o.Id,PricebookEntryId=context.entry.Id,Quantity=1.0,UnitPrice=75.00,
                                           FirstName__c='Testy',LastName__c='McTester',Email__c='foobar@gmail.com');
            insert line;
             
        	Registration.MORROW_EVENT_ID = context.e.Id;
    
			System.assert([SELECT Id FROM OrderItem WHERE OrderId= :o.Id].size()>0);
        
        	System.assert([SELECT Id, Product2.Event__c FROM OrderItem WHERE Id = :line.Id].Product2.Event__c == Registration.MORROW_EVENT_ID);
        
        	System.assert(Registration.hasEventTickets(new List<Id>{o.Id}, Registration.MORROW_EVENT_ID));
                          
			System.assert(!Registration.hasRegistrations(new List<Id>{o.Id}));
        
        	/*
        	 * Uncomment this if the OrderActivate Trigger is not active;
        	 * Otherwise, OrderActivate performs this check when the Order is put into
        	 *   Activated status.
        	 * 
            if(Registration.hasEventTickets(new List<Id>{o.Id}, Registration.MORROW_EVENT_ID) &&
               !Registration.hasRegistrations(new List<Id>{o.Id})){
                   Registration.createRegistrations(new List<Id>{o.Id}, Registration.MORROW_EVENT_ID);
                }
			*/
        
			// regs = Registration.createRegistrations(new List<Id>{o.Id}, Registration.MORROW_EVENT_ID);
        
            o.Status = 'Activated';
            update o;

        Test.stopTest();
        
        // System.assert(regs.size() > 0);
        
        List<Registration__c> results = [SELECT Id FROM Registration__c WHERE Order__c = :o.Id];
        System.assert(results.size() > 0);
    }    
}