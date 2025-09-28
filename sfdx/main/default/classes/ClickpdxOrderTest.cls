@isTest
private class ClickpdxOrderTest {
  
     
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
    
    
    
    public ClickpdxOrderTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        
        this.c = [SELECT Id, Name FROM Contact LIMIT 1];
        this.c.Ocdla_Member_Status__c = 'R';
        this.c.Ocdla_Membership_Expiration_Date__c = Date.newInstance(2030,6,30);
        
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
                      FirstName__c, LastName__c FROM OrderItem WHERE OrderId = :this.o.Id];
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }

    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxTest.setup(recordPrefix);        
    }
    
    private static testMethod void draftOrderFromShoppingCart(){
        ClickpdxOrderTest context = new ClickpdxOrderTest();
        OrderItem line = context.lines[0].clone(False,True);
        line.Contact__c = context.c.Id;
        line.PricebookEntryId = context.entry.Id;
        insert line;
        
        Order theOrder;
        Opportunity theOpp;
        Id theOrderId;
        
        Boolean hasCartErrors;
        
        ClickpdxShoppingCart clickpdxCart = new ClickpdxShoppingCart(context.a);
        clickpdxCart.persist();
        
        Map<String,Object> data; 
        
        /*
        ClickpdxCartResponse resp = clickpdxCart.response;
        
        hasCartErrors = null == resp.errors || resp.errors == False ? False : True;
        System.assert(!hasCartErrors, 'There were errors saving this Shopping Cart: '+clickpdxCart.responseData);
        */ 
        ClickpdxCartActionAddToCart.addProducts(clickpdxCart, new List<Product2>{context.p});

        theOpp = clickpdxCart.cart;
        
        Test.startTest();

        // theOrderId = ClickpdxOrder.draftOrderFromShoppingCart(theOpp.Id);
        theOrder = ClickpdxOrder.newFromShoppingCart(theOpp,new Map<String,String>{'ShippingStreet'=>'123 abc ave.'});
        
        Test.stopTest();
    }
    
    private static testMethod void largeShoppingCartCheckout(){
        ClickpdxOrderTest context = new ClickpdxOrderTest();
        
        ClickpdxShoppingCart cart;
        List<Contact> contacts = new List<Contact>();
        List<Map<String,String>> cartRequests = new List<Map<String,String>>();

        
        Order theOrder;
        
        Boolean hasCartErrors;
        
         
        for(Integer numContacts = 25, i=0; i<numContacts; i++){
            Contact c = new Contact(Id = null, FirstName=('Test-'+i),LastName=('Test-'+i),Email=('test-'+i+'@test.com'));
            contacts.add(c);
        }
        
        insert contacts;
        
        for(Contact c :contacts){
            Map<String,String> request = new Map<String,String>();
            request.put('pricebookEntryId',context.entry.Id);
            request.put('contactId',c.Id);
            cartRequests.add(request);
        }
        
        
        
        
        
        Test.startTest();
        
            
            cart = new ClickpdxShoppingCart(context.a);
            cart.persist();
            
            Map<String,Object> data; 
            
            /*
            ClickpdxCartResponse resp = cart.response;
            
            hasCartErrors = null == resp.errors || resp.errors == False ? False : True;
            System.assert(!hasCartErrors, 'There were errors saving this Shopping Cart: '+cart.responseData);
            */ 

            ClickpdxCartActionAddToCart.doAction(cart, cartRequests);

            
            System.assertEquals(25,cart.count(),'There should be 25 items in the cart but only found: '+cart.count());
    
            // theOrderId = ClickpdxOrder.draftOrderFromShoppingCart(theOpp.Id);
            theOrder = ClickpdxOrder.newFromShoppingCart(cart.getOpportunitySObect(),new Map<String,String>{'ShippingStreet'=>'123 abc ave.'});
        
        Test.stopTest();
    }
    
    private static testMethod void newFromShoppingCart(){
        ClickpdxOrderTest context = new ClickpdxOrderTest();
        Order theOrder;
        
        ClickpdxShoppingCart clickpdxCart = new ClickpdxShoppingCart(context.a);
        
        Test.startTest();
        
        theOrder = ClickpdxOrder.newFromShoppingCart(clickpdxCart.cart);
        
        Test.stopTest();
    }
    
    private static testMethod void newOrder(){
        ClickpdxOrderTest context = new ClickpdxOrderTest();
        ClickpdxOrder theOrder;
        
        Test.startTest();
        
        theOrder = new ClickpdxOrder();
        
        Test.stopTest();  
    } 
    
    private static testMethod void newOrderForAccount(){
        ClickpdxOrderTest context = new ClickpdxOrderTest();
        ClickpdxOrder theOrder;
        OrderItem line = context.lines[0].clone();
        Test.startTest();
        
        theOrder = new ClickpdxOrder(context.a.Id);
        theOrder.addItem(line);
        theOrder.save();
        
        Test.stopTest();  
    }
    
    
    private static testMethod void createPaidOfficeEventOrder(){
        ClickpdxOrderTest context = new ClickpdxOrderTest();
        Order theOrder;

        Test.startTest();
        
        theOrder = ClickpdxOrder.createPaidOfficeEventOrder(context.e.Id, context.a.Id);
 
        
        Test.stopTest();  
    }
    
}