@isTest
public class ClickpdxShoppingCartTest {
     
    static String recordPrefix = 'TEST002';  
     
    private static final String MEMBERSHIP_SUBCATEGORY_OPERATOR = 'Membership';
    
    private static final String PRODUCT_OPTION_FLAG = 'Option';
    
    public Account a; 
    
    public Contact c; 
    
    public Event__c evt;
    
    public Product2 ticketProduct;
    
    public PricebookEntry entry;  
     
     
    public ClickpdxShoppingCartTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];
        
        PriceBook2 nonMember = [SELECT Id, Name FROM PriceBook2 WHERE Name = :OrgOcdla.NON_MEMBER_PRICE_BOOK_NAME LIMIT 1];
        
        // Event testing - they often have related products
        this.evt = [SELECT Id, Name, Start_Date__c, Include_In_Catalog__c FROM Event__c WHERE Name LIKE :filter LIMIT 1];
        this.evt.Early_Bird_End_Date__c = System.today()+10;
        this.evt.Start_Date__c = System.today();
        this.evt.Include_In_Catalog__c = True;
        upsert this.evt; 
        
        
        this.ticketProduct = [SELECT Id, Name, ProductCode, Event__c FROM Product2
                       WHERE Id IN(SELECT Product2Id FROM PricebookEntry WHERE Pricebook2Id = :nonMember.Id)];
        this.ticketProduct.ProrationType__c = 'Quarterly';
        this.ticketProduct.Event__c = this.evt.Id;
        this.ticketProduct.GrantValue__c = 'SSM';
        update this.ticketProduct;

        
        Product_Relation__c r = new Product_Relation__c();
        r.IsActive__c = True;
        r.Event__c = this.evt.Id;
        r.Name = this.evt.Name + ': Hardcopy';
        r.Product__c = this.ticketProduct.Id;
        insert r;
        
        this.entry = [SELECT Id, UnitPrice, Product2.Id, Product2.Name, Product2.ClickpdxCatalog__LineDescription__c,
                      Product2.OcdlaMembershipStatusGrant__c FROM PricebookEntry WHERE Product2Id = :this.ticketProduct.Id LIMIT 1];
        this.entry.UnitPrice = 125.00;
        
        update this.entry;
    }
    
    @testSetup static void setup() {
        ClickpdxTest.setup(recordPrefix);
    }
    
    @isTest
    static void getMemberPrice(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();

		ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(context.entry.Id);
        PricebookEntry entry = manager.entry(context.entry.Id);
        
        Boolean isCurrentMember = ClickpdxCustomer.isCustomerCurrentMember();
        Boolean isCurrentMemberEmail = ClickpdxCustomer.isCurrentMemberEmail(context.c.Email);
        Contact c = ClickpdxCustomer.getContact(context.c.Email);
    }
    
    
    @isTest
    static void testPricebookEntry(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();

		ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(context.entry.Id);
        PricebookEntry entry = manager.entry(context.entry.Id);
        ClickpdxCartItem theItem = new ClickpdxCartItem(context.entry);
         theItem = new ClickpdxCartItem(context.entry, new Map<String,String>{});
        System.assertNotEquals(null, entry);
        System.assertEquals(125.00,entry.UnitPrice);
    }
    
    
    @isTest
    static void doExceptions(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
        ClickpdxCartItem theItem = new ClickpdxCartItem(context.entry);
        ClickpdxShoppingCartException ex = new ClickpdxShoppingCartException();
        ex.setProduct(theItem);
        ex.getProduct();
    }
    
    
    @isTest
    // instantiateShoppingCartAsGuest
    static void instantiateShoppingCart() {

        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
 
          
        Test.startTest();

            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
            Id OpportunityId = cart.save();
        
        	System.assertNotEquals(null, OpportunityId, 'Cart OpportunityId should not be null.');
        	System.assertEquals(0,cart.count());
        
        	cart = new ClickpdxShoppingCart();
			cart.save();
        	cart.forOpportunityId = cart.getId();

        	cart = new ClickpdxShoppingCart(context.a);
        
        	cart = ClickpdxShoppingCart.loadFromOpportunityId(OpportunityId);
        
        	cart = new ClickpdxShoppingCart(context.a,'My Shopping Cart');
        
        Test.stopTest();
    }
    
    @isTest
    static void makeResponseError(){
        
        ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        ClickpdxCartResponse resp = new ClickpdxCartResponse();
        
        String errorMessage = 'There was an error.';
        ClickpdxShoppingCartException e;
        
        try {
			e = new ClickpdxShoppingCartException(errorMessage);
            throw e;
        } catch(Exception assert){
            resp.addError(assert);            
        }

        
        System.assertEquals(True, resp.errors);
        System.assertEquals(e.getMessage(),resp.message);
    }

    
    
    @isTest
    static void createCartAction(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
		ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        Product2 testProduct = context.ticketProduct;

         
		ClickpdxCartAction action = new ClickpdxCartAction(ClickpdxCartActionType.ADD,testProduct);
        Id opportunityLineItemId = null;
        PricebookEntry entry = context.entry;
        Decimal price = context.entry.UnitPrice;
        Decimal defaultQuantity = 1.0;
        Decimal totalPrice = price*defaultQuantity;
        
        System.assertEquals(opportunityLineItemId, action.opportunityLineItemId, 'Opportunity Line Item Id should be null.');
        System.assertEquals(entry.Id,action.pricebookEntry.Id,'PricebookEntry Ids do not match.');
        System.assertEquals(price,action.getPrice(),'The Price for this CartAction is not correct.');
        System.assertEquals(defaultQuantity,action.quantity,'The Quantity for this CartAction should be 1.');
        System.assertEquals(totalPrice,action.getTotalPrice(),'The TotalPrice for this CartAction is incorrect.');
        // what kinds of things should we be testing?
        // 
        ClickpdxCartItem item1;
        item1 = action.getAsCartItem();
        
        Boolean exists = action.isExistingCartItem(cart);
        System.assertEquals(False,exists,'Cart Item should not exist in an empty cart.');
        
        cart.save();
        ClickpdxCartActionAddToCart.addProducts(cart, new List<Product2>{testProduct});
        exists = action.isExistingCartItem(cart); 
        System.assertEquals(True,exists,'Cart Item should now exist in the cart.');
        
		ClickpdxCartAction action2 = new ClickpdxCartAction(ClickpdxCartActionType.ADD,testProduct);
        ClickpdxCartItem item2 = action2.getAsCartItem(cart);
        System.assertEquals(2, item2.quantity, 'The quantity should be 2.');
        // Test that the items are identical
        // System.assertEquals(item2,item1,'Adding an identical item did not result in an identical ClickpdxCartItem.');
        cart.addItem(item2);
        // System.assertEquals(1,cart.count(),'There should only be one item in the cart.');
    } 
    
    @isTest
    static void saveCart(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
        
        Test.startTest();
        
            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	Id OpportunityId = cart.save();
        
        Test.stopTest();
    }
    
    @isTest
    static void removeCartItem(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
         
        Test.startTest();
        
            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	Id OpportunityId = cart.save();
        
        	System.assertEquals(0,cart.count());
        
			ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(context.ticketProduct);
            List<ClickpdxCartItem> items = ClickpdxCartActionAddToCart.addProducts(cart, new List<Product2>{context.ticketProduct});
        	cart.save();
        	System.assertEquals(1,cart.count());
        
        	Id OpportunityLineItemId = items[0].key();
        	ClickpdxShoppingCart.removeCartItem(OpportunityLineItemId);
        
        	cart = ClickpdxShoppingCart.loadFromOpportunityId(OpportunityId);
        
        	System.assertEquals(0,cart.count());
        
        Test.stopTest();
    }
    
    @isTest
    static void addCartItems() { 

        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
  
        
        Test.startTest();

            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	Id Opportunityid = cart.save();
        
        	System.assertEquals(0,cart.count()); 
        
			ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(context.ticketProduct);
            ClickpdxCartActionAddToCart.addProducts(cart, new List<Product2>{context.ticketProduct});
        	cart.save();

        	System.assertEquals(1,cart.count());
        
            ClickpdxCartActionAddToCart.addProducts(cart,new List<Id>{context.entry.Id});
        
			ClickpdxCartItem theItem = ClickpdxCartActionAddToCart.addToCart(cart, context.entry, context.c);

        Test.stopTest();
    }
    
    
    @isTest
    static void addEventRegistration() { 

        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
  
        
        Test.startTest();

            ClickpdxShoppingCart customerCart = new ClickpdxShoppingCart(context.a);
        	Id Opportunityid = customerCart.save();
        
        	String customerEmail = 'test@abc.com';
        
        	System.assertEquals(0,customerCart.count());

            // Set the PricebookEntryId and Quantity
        	Map<String,Object> userInput = new Map<String,Object>();
            userInput.put('pricebookEntryId',context.entry.Id);
        	userInput.put('quantity',1);
        
            // Also pass sample FirstName__c,LastName__c and Email__c fields.
            userInput.put('firstName','Testy');
        	userInput.put('lastName','McTester');
        	userInput.put('email',customerEmail);
            
            ClickpdxCartResponse resp = customerCart.doAction('add',userInput);
        	customerCart.save();
        
			ClickpdxCartItem item = resp.affectedItems[0];
        	System.debug(item);
        
        	// The saved registration should reflect the registrants name and email.
        	System.assertEquals(item.email,customerEmail,'The registrant\'s email was not successfully saved.');

        	System.assertEquals(1,customerCart.count());
        
			Id orderId = ClickpdxOrder.draftOrderFromShoppingCart(customerCart.getId());
        
        	OrderItem registration = [SELECT FirstName__c, LastName__c, Email__c FROM OrderItem WHERE OrderId = :orderId LIMIT 1 ];
        
        	System.assertEquals(registration.Email__c,customerEmail,'The registrant\'s email was not successfully saved to the Order.');

        Test.stopTest();
    }
    

    @isTest
    static void removeItems(){
        
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
  
        
        Test.startTest();

            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	Id Opportunityid = cart.save();
        
        	System.assertEquals(0,cart.count());
        
			ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(context.ticketProduct);
            List<ClickpdxCartItem> affectedItems = ClickpdxCartActionAddToCart.addProducts(cart, new List<Product2>{context.ticketProduct});
        	cart.save();

        	System.assertEquals(1,cart.count()); 
        

         
            Map<String,String> params = new Map<String,String>();
            params.put('opportunityLineItemId', affectedItems[0].opportunityLineItemId);
            List<ClickpdxCartItem> deletedItems = ClickpdxCartActionRemoveFromCart.doAction(cart, params);
        
        	System.assertNotEquals(null,deletedItems,'The result of removing the product should not be null.');
        			
        
        Test.stopTest();
    }



    @isTest
    static void hasAccess(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
  
        
        Test.startTest();

        	Test.setCurrentPage(Page.OcdlaProduct);
        	ApexPages.currentPage().getParameters().put('id',context.entry.Product2Id);
        
        	OcdlaProductController controller = new OcdlaProductController();
         
            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	Id Opportunityid = cart.save();
        
        	cart.persistAction();
         
        	ApexPages.currentPage().getParameters().put('pricebookEntryId',context.entry.Id);
        	ClickpdxCartResponse response = cart.doAction('add',ApexPages.currentPage().getParameters());
        	List<ClickpdxCartItem> affectedItems = response.affectedItems;
        
        	Boolean isCurrentMember = MembersOnlyAccess.hasAccess(affectedItems[0]);
        	Boolean hasPermission = MembersOnlyAccess.isMembersOnly(affectedItems[0]);
        	Boolean isUserCurrentMember = MembersOnlyAccess.isUserCurrentMember(UserInfo.getUserId());
        Test.stopTest();
    }

    
    @isTest
    static void doVisualforceActions(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
  
        
        Test.startTest();

        	Test.setCurrentPage(Page.OcdlaProduct);
        	ApexPages.currentPage().getParameters().put('id',context.entry.Product2Id);
        
        	OcdlaProductController controller = new OcdlaProductController();
         
            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	Id Opportunityid = cart.save();
        
        	cart.persistAction();
        
        	ApexPages.currentPage().getParameters().put('pricebookEntryId',context.entry.Id);
        	ClickpdxCartResponse response = cart.doAction('add',ApexPages.currentPage().getParameters());
        	List<ClickpdxCartItem> affectedItems = response.affectedItems;
         

        if(response.errors){
            throw new System.AssertException(response.message);
        }
        	System.assertEquals(False,response.errors);
        	System.assertEquals(1,affectedItems.size(),'There should be 1 item in the cart.');
        
        	Map<String,String> params = new Map<String,String>();
        	params.put('pricebookEntryId',context.entry.Id);
        	params.put('quantity','2.0');
        	params.put('opportunityLineItemId',affecteditems[0].key());
        	ApexPages.currentPage().getParameters().putAll(params);
        
        	cart.updateAction();
        
        Test.stopTest();
    }
    
    @isTest
    static void loadCartInProductPage(){
        
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
        
        Test.startTest();
        
        	Test.setCurrentPage(Page.OcdlaProduct);
        	ApexPages.currentPage().getParameters().put('id',context.entry.Product2Id);
        
        	OcdlaProductController controller = new OcdlaProductController();
        	System.assertEquals(context.entry.Product2Id, controller.theProduct.Id);
        
        
        	Id originalId;
        	Id cookieId;
        
        	ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	cart.persistAction();
        	originalId = cart.getId();
        
        	cart = ClickpdxShoppingCart.loadFromSessionShoppingCartId();
        	cookieId = cart.getId();
        
        	// By default should load the Shopping Cart with values from cookie.
        	ClickpdxShoppingCart testContructor = new ClickpdxShoppingCart();
        
        	System.assertEquals(originalId, cookieId, 'Cookie cart Id does not match original cart Id.');
        
        	Id someNewCartId = ClickpdxShoppingCart.persistCartRemote();
        
        Test.stopTest();
    }
    
    @isTest
    static void checkShippables(){
        ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        cart.save();
        
        Boolean hasShippables;
        
        hasShippables = ClickpdxShoppingCart.hasShippableProducts(cart.getId());
    }
    
    
    @isTest
    static void testCartItems(){
        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
        
        
        ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        cart.save();
        
        List<ClickpdxCartItem> items = ClickpdxCartActionAddToCart.addProducts(cart, new List<Product2>{context.ticketProduct});
        Id OpportunityId = cart.save();
         
        ClickpdxCartItem compat = items[0].getJsonCompatible();
        items[0].getSObject();
        
        ClickpdxCartItem.loadFromOpportunityIdByEventTicket(OpportunityId,context.evt.Id);
    }
    
    @isTest
    static void getExceptions(){
        String message = 'An error message';
        ClickpdxShoppingCartException e = new ClickpdxShoppingCartException(message);
        
        ClickpdxShoppingCartInvalidFormException ex = new ClickpdxShoppingCartInvalidFormException(message);
        ex.addForms(new List<String>{'hello'});
        ex.addForm('hello');
        
        ClickpdxShoppingCartInvalidFormException exe = new ClickpdxShoppingCartInvalidFormException(message);
		exe.addForm('hello');
        
    }
    
    @isTest
    static void doCheckout() {

        ClickpdxShoppingCartTest context = new ClickpdxShoppingCartTest();
  
        
        Test.startTest();

        	Test.setCurrentPage(Page.OcdlaProduct);
        	ApexPages.currentPage().getParameters().put('id',context.entry.Product2Id);
        
        	OcdlaProductController controller = new OcdlaProductController();
        
            ClickpdxShoppingCart cart = new ClickpdxShoppingCart();
        	Id oldCartId = cart.save();
        	cart.persistAction();
        	cart.checkout();
        	cart.convertOpportunityToWon();
        
        	// Since sessions are enabled this would throw an error inside the constructor as
        	// the Opportunity has already been converted to "Closed Won" status.
        	ClickpdxShoppingCartCookie.setShoppingCartId(oldCartId);
        	cart = new ClickpdxShoppingCart();
         
        Test.stopTest();
    }

}