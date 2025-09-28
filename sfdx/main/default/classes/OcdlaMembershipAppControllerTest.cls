@isTest
public class OcdlaMembershipAppControllerTest {
     
	public OrderApi__Item_Class__c theItemClass;
    
    public OrderApi__Item__c theItem;  
    
	private static final String MEMBERSHIP_SUBCATEGORY_OPERATOR = 'Membership';
    
    private static final String PRODUCT_OPTION_FLAG = 'Option';
    
    public OcdlaMembershipAppControllerTest(){}
     

    static testMethod void loadProductAppPage() {
		// Variable initialization.
        Clickpdx_Test_Base tma = new Clickpdx_Test_Base();
        
        // Item initialization.
        tma.theItem.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        tma.theItem.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR);
        upsert tma.theItem;

        
        StoreProductAppController memApp1 = new StoreProductAppController();
        PageReference step1 = Page.ClickpdxProductApp;
        

        
        
        // Set up our page.
        step1.getParameters().put('subcategory', MEMBERSHIP_SUBCATEGORY_OPERATOR);
        step1.getParameters().put('selectedMembershipId', tma.theItem.Id);

        
        Test.startTest();
        
        Test.setCurrentPage(step1);

        
        Test.stopTest();
    }
    
    
    
    static testMethod void errorNoPrimaryMembershipSelected(){
		// Variable initialization.
        Clickpdx_Test_Base tma = new Clickpdx_Test_Base();
        
        
        // Primary membership item initialization.
        tma.theItem.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        tma.theItem.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR);
        upsert tma.theItem;


        
        // Here's our page and related parameters necessary for setup.
        PageReference step1 = Page.OcdlaMembershipApp;
        step1.getParameters().put('accid', tma.a.Id);
        step1.getParameters().put('conid', tma.c.Id);
        


        // Set up our page
        step1.getParameters().put('subcategory', MEMBERSHIP_SUBCATEGORY_OPERATOR);
		
        

        
        test.startTest();
        

        Test.setCurrentPage(step1);
        
        // Instantiate the page controller.
        OcdlaMembershipAppController memApp1 = new OcdlaMembershipAppController();
        
        // MemberAppStep1Controller.ProductWrapper mWrapper;
        // mWrapper = new MemberAppStep1Controller.ProductWrapper(tma.theItem);
        // mWrapper.selected = True;
        
        // Set a valid value for the "primary" membership product.
		memApp1.selectedMemTypeId = null;
        
        
        // Create and close a Sales Order with the above membership-related products.
        memApp1.Checkout();
    }
    
    static testMethod void testPageLoad() {
		// Variable initialization.
        Clickpdx_Test_Base tma = new Clickpdx_Test_Base();
        
        // Item initialization.
        tma.theItem.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        tma.theItem.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR);
        upsert tma.theItem;

        
        OcdlaMembershipAppController memApp1 = new OcdlaMembershipAppController();
        // StoreProductAppController.ProductWrapper mWrapper;
        PageReference step1 = Page.OcdlaMembershipApp;
        

        
        
        // Set up our page.
        step1.getParameters().put('subcategory', MEMBERSHIP_SUBCATEGORY_OPERATOR);
        step1.getParameters().put('selectedMembershipId', tma.theItem.Id);
		
        // mWrapper = new MemberAppStep1Controller.ProductWrapper(tma.theItem);
        // mWrapper.selected = True;
        
        Test.startTest();
        
        Test.setCurrentPage(step1);

        memApp1.updateMembership();
        memApp1.tempMethod();  
        // memApp1.save();
        memApp1.previous(); 
        
        Test.stopTest();
    }
    
    
    static testMethod void testSelectAddOns() {
		// Variable initialization.
        Clickpdx_Test_Base tma = new Clickpdx_Test_Base();
        
        // Create a test Item
        OrderApi__Item__c membershipAddOn = tma.theItem.clone();
        
        
        // Primary membership item initialization.
        tma.theItem.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        tma.theItem.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR);
        upsert tma.theItem;

        // "Secondary" membership add-on initialization.
        membershipAddOn.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        membershipAddOn.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR+';'+PRODUCT_OPTION_FLAG);
        insert membershipAddOn;
        
        // Here's our page and related parameters necessary for setup.
        PageReference step1 = Page.OcdlaMembershipApp;
        step1.getParameters().put('accid', tma.a.Id);
        step1.getParameters().put('conid', tma.c.Id);
        


        // Set up our page
        step1.getParameters().put('subcategory', MEMBERSHIP_SUBCATEGORY_OPERATOR);
		
        

        
        test.startTest();
        

        Test.setCurrentPage(step1);
        
        // Instantiate the page controller.
        OcdlaMembershipAppController memApp1 = new OcdlaMembershipAppController();
        
        // MemberAppStep1Controller.ProductWrapper mWrapper;
        // mWrapper = new MemberAppStep1Controller.ProductWrapper(tma.theItem);
        // mWrapper.selected = True;
        
        // Set a valid value for the "primary" membership product.
        step1.getParameters().put('selectedMembershipId', tma.theItem.Id);
		memApp1.updateMembership();
        
        // Pass a valid value corresponding to the secondary, "add-on" product.
        step1.getParameters().put('selectedMembershipAddOns', membershipAddOn.Id);
        memApp1.updateMembershipAddOns();
        
        // Create and close a Sales Order with the above membership-related products.
        memApp1.Checkout();
        
        // If there were any errors at Checkout then display them for the unit test.
       	System.assertNotEquals(memApp1.getHasError(), True, memApp1.errorMessage + '<p>' + memApp1.debugMessage+'</p>');
        
        test.stopTest();
    }
    
    
    static testMethod void testCheckout() {
		// Variable initialization.
        Clickpdx_Test_Base tma = new Clickpdx_Test_Base();
        
        // Create a test Item
        OrderApi__Item__c membershipAddOn = tma.theItem.clone();
        
        
        // Primary membership item initialization.
        tma.theItem.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        tma.theItem.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR);
        upsert tma.theItem;

        // "Secondary" membership add-on initialization.
        membershipAddOn.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        membershipAddOn.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR+';'+PRODUCT_OPTION_FLAG);
        insert membershipAddOn;
        
        // Here's our page.
        PageReference step1 = Page.OcdlaMembershipApp;
        step1.getParameters().put('accid', tma.a.Id);
        step1.getParameters().put('conid', tma.c.Id);
        

        
        test.startTest();
        
        Test.setCurrentPage(step1);
        
        // Instantiate the page controller.
        OcdlaMembershipAppController memApp1 = new OcdlaMembershipAppController();
        
        // Set up our page.
        step1.getParameters().put('subcategory', MEMBERSHIP_SUBCATEGORY_OPERATOR);
        step1.getParameters().put('selectedMembershipId', tma.theItem.Id);
        step1.getParameters().put('selectedMembershipAddOns', tma.theItem.Id);
        
        // OcdlaMembershipAppController.ProductWrapper mWrapper;
		// mWrapper = new OcdlaMembershipAppController.ProductWrapper(tma.theItem);
        // mWrapper.selected = True;
        
        
		memApp1.updateMembership();
        memApp1.Checkout(); 
        
        test.stopTest();
    }

    static testMethod void testClickpdxSalesOrder() {
		// Variable initialization.
        Clickpdx_Test_Base tma = new Clickpdx_Test_Base();
        
        // Create a test Item
        OrderApi__Item__c membershipAddOn = tma.theItem.clone();
        
        
        // Primary membership item initialization.
        tma.theItem.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        tma.theItem.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR);
        upsert tma.theItem;

        // "Secondary" membership add-on initialization.
        membershipAddOn.put(OcdlaMembershipAppController.IS_APP_AVAILABLE_FIELD_NAME,True);
        membershipAddOn.put(OcdlaMembershipAppController.CATEGORY_FIELD_NAME,MEMBERSHIP_SUBCATEGORY_OPERATOR+';'+PRODUCT_OPTION_FLAG);
        insert membershipAddOn;
        
        // Create a new Sales Order instance from the test Account and Contact.
        ClickpdxSalesOrder theOrder = new ClickpdxSalesOrder(tma.c, tma.a);
        theOrder.addLineItem(tma.theItem.Id, tma.c.Id, 1);
        theOrder.addLineItem(tma.theItem.Id, tma.c.Id);
        
		OrderApi__Sales_Order_Line__c theLine = ClickpdxSalesOrder.getSalesOrderLine(tma.theItem);
        
		OrderApi__Sales_Order_Line__c anotherLine = ClickpdxSalesOrder.getSalesOrderLine(tma.theItem, tma.c);
        
        // Test adding multiple Line Items.
        List<OrderApi__Sales_Order_Line__c> addedLines = theOrder.addLineItems(new List<String>{tma.theItem.Id, membershipAddOn.Id});
        Integer expectedAddedListCount = 2;
        System.assertEquals(expectedAddedListCount, addedLines.size(), 'Expected item count should have increased by '+expectedAddedListCount+'. Actual was '+addedLines.size());
    }
    
}