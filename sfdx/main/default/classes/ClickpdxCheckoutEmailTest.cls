@isTest
public class ClickpdxCheckoutEmailTest {
    
    private static String recordPrefix = 'TEST003';
    
    public Event__c evt;  
    
    public Account a;
      
    public Product2 p; 
    
    public Order o;
     
    List<OrderItem> lines;
    
    
     
    public ClickpdxCheckoutEmailTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        
        this.p = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        
        Contact c = [SELECT Id, FirstName, LastName FROM Contact LIMIT 1];
        
        this.o = [SELECT Id, ShipToContactId, BillToContactId, OrderNumber, AccountId, OpportunityId, TotalAmount FROM Order LIMIT 1];
        this.o.BillToContactId = c.Id;
        upsert o;
        
        
        this.lines = [SELECT Id, Description, UnitPrice, TotalPrice, Quantity, Contact__c,
                      FirstName__c, Product2Id, LastName__c FROM OrderItem WHERE OrderId = :this.o.Id];
    }
    
    
    @testSetup static void setup() {
        testSetup();
    }
    
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxTest.setup(recordPrefix);        
    }
    
    
    @isTest
    static void loadCheckoutEmail() {
		ClickpdxCheckoutEmailTest context = new ClickpdxCheckoutEmailTest();

         
        Test.startTest();
		
            ClickpdxCheckoutEmailLineItemSummary checkoutEmail = new ClickpdxCheckoutEmailLineItemSummary();
            checkoutEmail.o = context.o;
            
            checkoutEmail.getParentProducts(new List<Id>());
            
            List<ClickpdxCheckoutEmailLineItemSummary.ClickpdxOrderLineItem> testSalesOrderLines = checkoutEmail.getFormattedLineItems();
            
            String total = checkoutEmail.soTotal;
            
            
            ClickpdxCheckoutEmailLineItemSummary.ClickpdxOrderLineItem theTestCheckoutLineItem = new ClickpdxCheckoutEmailLineItemSummary.ClickpdxOrderLineItem(context.lines[0]);
            String lineQty = theTestCheckoutLineItem.qty;
            
            String lineNo = 			theTestCheckoutLineItem.lineNo;
            String price = 				theTestCheckoutLineItem.price;
            String description = 		theTestCheckoutLineItem.description;
            String subtotal = 			theTestCheckoutLineItem.subtotal;
            String qty = 				theTestCheckoutLineItem.qty;
            String downloadFileName = 	theTestCheckoutLineItem.downloadFileName;
            
        Test.stopTest();
    }

    
}