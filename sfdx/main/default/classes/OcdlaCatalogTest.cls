@isTest
public class OcdlaCatalogTest {
       
    private static String recordPrefix = 'TEST003';
     
    private static String MEMBER_STATUS_LAW_STUDENT_MEMBERSHIP = 'A';
    
    private static String MEMBER_STATUS_REGULAR_MEMBERSHIP = 'R';
    
    private static final String PAID_OFFICE_MEMBERSHIP_OPPORTUNITY_NAME = 'Paid Office Membership Renewal';
    
    public Account a; 
    
    public Contact c;
    
    public Product2 p;
    
    public PricebookEntry entry;
    
    public OrderApi__Catalog__c theCatalog;
     
    public OcdlaCatalogTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        
		Ocdla_Apps__c orgSettings = new Ocdla_Apps__c();
        orgSettings.Ocdla_Current_Membership_Term_End_Date__c = System.today();
        insert orgSettings;
        
        this.p = [SELECT Id, Name, Family, Description FROM Product2 LIMIT 1];
        this.p.OcdlaMembershipStatusGrant__c = MEMBER_STATUS_REGULAR_MEMBERSHIP;
        this.p.Family = OcdlaAccountMembershipRenewal.MEMBERSHIP_PRODUCT_FAMILY;
        upsert this.p;
        
        this.entry = [SELECT Id,Product2Id FROM PricebookEntry WHERE Product2Id = :this.p.Id];
        this.entry.IsActive = True;
        upsert this.entry;
        
        System.assertEquals(this.entry.Product2Id, this.p.Id, 'The Product does not match the referenced Pricebook Entry.');
        
        this.a = [SELECT Id, Name, OrderApi__Primary_Contact__c FROM Account LIMIT 1];
        
        this.c = [SELECT Id, FirstName, LastName, Ocdla_Current_Member_Flag__c, AccountId, Email FROM Contact WHERE Name LIKE :filter LIMIT 1];
        this.c.AccountId = this.a.Id;
        this.c.Ocdla_Member_Status__c = 'R';
        this.c.Ocdla_Membership_Expiration_Date__c = System.today().addYears(1);
        upsert this.c;
        
        this.a.OrderApi__Primary_Contact__c = c.Id;
        upsert a;
        
        this.c = [SELECT Id, FirstName, LastName, Ocdla_Current_Member_Flag__c, AccountId, Email FROM Contact WHERE Id = :this.c.Id];
        
        System.assertEquals(True,this.c.Ocdla_Current_Member_Flag__c, 'The Contact should be considered a Current Member but is not.');
        
        this.theCatalog = new OrderApi__Catalog__c(Name='Publications');
        insert theCatalog;
        
        OrderApi__Catalog_Item__c catItem = new OrderApi__Catalog_Item__c(OrderApi__Is_Published__c=True,OrderApi__Catalog__c=theCatalog.Id,Product__c=p.Id);
        insert catItem;
    }
      
     
    @testSetup
    static void setup() {
        testSetup();
    } 
     
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxCore.TestBase.setup(recordPrefix);        
    }
    
    @isTest
    static void retrieveCatalogItemsByCatalogName(){

        Test.startTest();
            
            OcdlaCatalogTest context = new OcdlaCatalogTest();
            
            CatalogProductList theCatalog = OcdlaCatalogController.retrieveItems(context.theCatalog.Id);
            theCatalog.findAll();
            
            Test.setCurrentPage(Page.OcdlaCatalog);
            
        
        Test.stopTest();
    }
    
    @isTest
    static void buildMenu(){
        

        
        Test.startTest();
    
            OcdlaCatalogTest context = new OcdlaCatalogTest();
            
            OcdlaCatalogController theTest = new OcdlaCatalogController();
            
            MenuItem theRoot;
            
            theRoot = new MenuItem(context.theCatalog.Id); 
    
            
            OrderApi__Catalog__c subCat = new OrderApi__Catalog__c(Name='SubPublications',OrderApi__Catalog__c = context.theCatalog.Id);
            insert subCat;
            
            System.assert(theRoot.hasChildren(), 'Sub menu was added to Publications but is showing as having no children.');
            
            OcdlaCatalogController.getMenuHtml();
            
            OcdlaCatalogController.cacheCatalog();
            
        Test.stopTest();
    }
    

    @isTest
    static void loadCatalogPage(){


    	MenuItem item = OcdlaCatalogController.getMenu();

        
		CatalogException error = new CatalogException();
        
        OcdlaCatalogTest context = new OcdlaCatalogTest();
        
        
        Product2 p = [SELECT Id, Name, ClickpdxCatalog__DisplayName__c, (SELECT Id, UnitPrice, Discounts__c FROM PricebookEntries) FROM Product2
                      WHERE Id = :context.p.Id ORDER BY ClickpdxCatalog__DisplayOrder__c NULLS LAST, ClickpdxCatalog__DisplayName__c];
        
        CatalogProduct prod1 = new CatalogProduct(p);
        CatalogProduct prod2 = new CatalogProduct(p);
        prod1.compareTo(prod2);

        Test.startTest();
            
    
            String catalogName = context.theCatalog.Name;
            
            Test.setCurrentPage(Page.OcdlaCatalog);
            ApexPages.currentPage().getParameters().put('name',catalogName);
            OcdlaCatalogController ctrl = new OcdlaCatalogController();

        Test.stopTest();
    }
    
    
    @isTest
    static void loadStoreHome(){

		OcdlaCatalogTest context = new OcdlaCatalogTest();

        Test.startTest();
            
    
            String catalogName = context.theCatalog.Name;
            
            Test.setCurrentPage(Page.Store);
            ApexPages.currentPage().getParameters().put('name',catalogName);
            OcdlaCatalogController ctrl = new OcdlaCatalogController();
            OcdlaCommunityTemplateController theme = new OcdlaCommunityTemplateController();

        Test.stopTest();
    }


}