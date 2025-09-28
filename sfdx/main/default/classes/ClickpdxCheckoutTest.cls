@isTest
public class ClickpdxCheckoutTest {
    
    private static String recordPrefix = 'TEST003';
    
    public Event__c evt;  
     
    public Account a; 
     
    public Product2 p;
    
    public Opportunity opp; 
    
      
       
    public ClickpdxCheckoutTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        
        Contact c = [SELECT Id FROM Contact WHERE AccountId = :this.a.Id LIMIT 1];
   
        
        this.p = [SELECT Id, Name, OcdlaMembershipStatusGrant__c, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        this.p.OcdlaMembershipStatusGrant__c = 'R';
        this.p.Family = 'Capital Defenders Memberships';
        upsert this.p;
        
        PricebookEntry entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :this.p.Id LIMIT 1];
        
        OpportunityLineItem line = new OpportunityLineItem(PricebookEntryId = entry.Id, Contact__c = c.Id);
        
        this.opp = [SELECT Id, Name FROM Opportunity WHERE Name LIKE :filter LIMIT 1];
        
        line.OpportunityId = this.opp.Id;
        line.UnitPrice = 255.00;
        line.Quantity = 1.0;
        insert line;
        
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }
    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxTest.setup(recordPrefix);        
    }
    

    @isTest
    private static void loadCheckoutPage() {
		ClickpdxCheckoutTest context = new ClickpdxCheckoutTest();

        
        Test.startTest();
			Order o;
        
            PageReference thePage = Page.OcdlaCheckout;
            thePage.getParameters().put('id', context.opp.Id);
            Test.setCurrentPage(thePage);
        
            ClickpdxCheckoutController ctrlExt = new ClickpdxCheckoutController();
 			ctrlExt.getRenderPayment();
        	ctrlExt.getIsEmptyOrder();
        	ctrlExt.getOpp();
        	ctrlExt.getIsPaid();

			String theEmail = ctrlExt.getOrderEmail();
        	ClickpdxCheckoutController.checkOrderEmail(theEmail);
        
        	ctrlExt.getOrderLines();
        
        	Contact guestContact = new Contact(FirstName = 'Jane',LastName='Doe',Email='jdoe@jdoe.com.foobar');
        	ClickpdxCheckoutController.generateGuestCheckoutContact(guestContact,context.opp.Id);
        
        	Map<String,String> billingData = new Map<String,String>();
        	o = ClickpdxCheckoutController.processOrderStub(context.opp.Id,billingData);
        	o = ClickpdxCheckoutController.finalizeOrder(o.Id,new Map<String,String>{'ccNum'=>'123456'});
        	
        OcdlaMembership.evaluateMemberships(o.Id);
        
        ctrlExt.setDefaults();

        
        
        Test.stopTest();
        
        o = [SELECT Id, OrderNumber, EffectiveDate, Status, OpportunityId, AccountId, BillToContactId,
                               ShipToContactId, PriceBook2Id FROM Order WHERE Id = :o.Id];
        // Test that the Order and the related Shopping Cart are related
        System.assertEquals(context.opp.Id, o.OpportunityId, 'The Order OpportunityId, '+o.OpportunityId+', does not match the converted Opportunity\'s Id of '+context.opp.Id+'.');
        
        List<OrderItem> orderLines = [SELECT Id FROM OrderItem WHERE OrderId = :o.Id];
        List<OpportunityLineItem> oppLines = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :context.opp.Id];
        
        System.assertEquals(oppLines.size(), orderLines.size(), 'The number of order lines, '+orderLines.size()+ ', does not match the number of passed Opportunity lines, '+oppLines.size());
        
        
    }

    
     @isTest static void doPayment() {
         
         Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ClickpdxResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res;
         
        // Instantiate the callout service. 
        ClickpdxHttpCallout svc = new ClickpdxHttpCallout();
        svc = new ClickpdxHttpCallout('OcdlaCCAuthorize');
        String response = svc.getResponse();
         
        res = svc.res;
        
		res = svc.createHttpErrorResponse(404,'Not Found');
         
        Test.stopTest();
 
        String contentType = res.getHeader('Content-Type');
        String actualValue = res.getBody();

        // Verify response received contains fake values         
        // System.assert(contentType == 'application/json');
        // String expectedValue = '{"foo":"bar"}';
        // System.assertEquals(actualValue, expectedValue);
        // System.assertEquals(200, res.getStatusCode());
    }


    
}