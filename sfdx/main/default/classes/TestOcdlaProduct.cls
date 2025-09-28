@isTest
public class TestOcdlaProduct {
    
    private static String recordPrefix = 'TEST003'; 
    
    public Account a;
     
    public Contact c;
    
    public Product2 p;
   	
    public OrderItem oI;  
    
    public Order o;
    
    public PriceBookEntry pB;
     
    
    // contact/account needs product to be connected, product needs orderItem and order respectively
    public TestOcdlaProduct(){
        Id userId = '00505000002LWSIAA4';
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        
        this.p = [SELECT Id, Name, Description FROM Product2 LIMIT 1];
        this.p = new Product2(Name = 'Books Online Subscription', IsActive = true, CLickpdxCatalog__IsParent__c = false);
        insert this.p;
        this.p = [SELECT Id FROM Product2 WHERE Name = 'Books Online Subscription' LIMIT 1];
        
        this.pB = new PricebookEntry(Product2Id = this.p.Id, Pricebook2Id = '01sj0000001pjB9AAI', UnitPrice = 10);
        Insert this.pB;
        this.pB = [SELECT Id, Product2Id, Pricebook2Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :this.p.Id LIMIT 1];
        
        this.a = new Account(Name = 'Mr Test Man 9000');
        insert this.a;
        this.a = [SELECT Id,Name FROM Account WHERE Name = 'Mr Test Man 9000' LIMIT 1];
        
        this.c = new Contact(FirstName = 'Mr Test Man 9000', LastName = 'Dudeman', AccountId = this.a.Id);
        insert this.c;
        this.c = [SELECT Id,AccountId,FirstName FROM Contact WHERE FirstName = 'Mr Test Man 9000' LIMIT 1];
        
        this.o = new Order(EffectiveDate = Date.today(), Status = 'Draft',
                           Pricebook2Id = this.pB.Pricebook2Id, AccountId = this.a.Id);
        insert this.o;
        this.o = [SELECT Id,EffectiveDate FROM Order WHERE AccountId = :this.a.Id AND Pricebook2Id = :this.pB.Pricebook2Id LIMIT 1];
        
        this.oI = new OrderItem(OrderId = this.o.Id, Contact__c = this.c.Id, 
                                PricebookEntryId = this.pB.Id, UnitPrice = this.pB.UnitPrice, Quantity = 1);
        insert this.oI;
        this.oI = [SELECT Id,OrderId,Contact__c FROM OrderItem WHERE OrderId = :this.o.Id LIMIT 1];
        // this.c = [SELECT Id, FirstName, LastName, AccountId, Email FROM Contact WHERE Name LIKE :filter LIMIT 1];
    }
      
     
    @testSetup static void setup() {
        testSetup();
    } 
     
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxCore.TestBase.setup(recordPrefix);        
    }
/*
    @isTest
    private static void TestRetrievingProductsByName() {
        TestOcdlaProduct env = new TestOcdlaProduct();
        string productName = 'Cheddar Cheese';
        // List<Product2> products = OcdlaProductController.GetProductsByName(productName);
        // system.Assert(products.size() == 0, 'There should be no cheddar cheese products in the ocdla database');
        // productName = 'Books Online Subscription';
        // List<Product2> products2 = OcdlaProductController.GetProductsByName(productName);
        // system.Assert(products2.size() > 0, 'There should be a Books Online Subscription product in the ocdla database');
    }
    
    @isTest
    private static void TestGetExpirationDate() {
        TestOcdlaProduct env = new TestOcdlaProduct();
        Contact c = [SELECT Id,AccountId,FirstName FROM Contact WHERE FirstName = 'Mr Test Man 9000' LIMIT 1];
        Date expirationDate = OcdlaProductController.GetExpirationDate(c.Id);
        
        system.Assert(expirationDate == Date.today().addDays(365), 'The expiration date should one year from today.');
    }
    
    @isTest
    private static void TestGetOrderItems() {
        TestOcdlaProduct env = new TestOcdlaProduct();
        
        List<Product2> Product2Ids = OcdlaProductController.GetProductsByName('%Books Online Subscription%');
        //ignore 123 if test.isRunningTest() = true;
        Contact theCustomerContact = [SELECT Id,Name FROM Contact WHERE FirstName = 'Mr Test Man 9000' LIMIT 1];
        
        List<Order> customerOrderItems = OcdlaProductController.GetOrderIds(Product2Ids, theCustomerContact);
        
        system.Assert(customerOrderItems.size() > 0, 'There should be orders that this user made for a books online product');
    }
*/
    @isTest
    private static void doProductPageDisplay(){
        TestOcdlaProduct context = new TestOcdlaProduct();
        
        Test.startTest();
        
        PageReference thePage = Page.OcdlaProduct;
        thePage.getParameters().put('id',context.p.Id);
        
        Test.setCurrentPage(thePage);

        OcdlaTemplateStoreController theme = new OcdlaTemplateStoreController();  
        String profileUrl = theme.getProfileUrl();
        String loginUrl = theme.getLoginUrl();
        String logoutUrl = theme.getLogoutUrl();
        OcdlaProductController c = new OcdlaProductController();
        OcdlaProductController.getTargetUrlProduct2Id(context.p.Id);
		OcdlaProductController.ProductOption opt = new OcdlaProductController.ProductOption(c.entry);
        Decimal memberPrice = opt.memberPrice;
        Test.stopTest();
    }
   
    @isTest
    private static void testProductPriceTrigger(){
        TestOcdlaProduct context = new TestOcdlaProduct();
        
        Test.startTest();

        
        Product2 theProduct = context.p;//.clone();
        theProduct.ClickpdxCatalog__StandardPrice__c = 125.25;
        theProduct.ClickpdxCatalog__MemberPrice__c = 125.25;
        upsert theProduct;
        
        Test.stopTest();
    }

    
    
    
}