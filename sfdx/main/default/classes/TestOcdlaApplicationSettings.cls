@isTest
public class TestOcdlaApplicationSettings {
    
    private static String recordPrefix = 'TEST003';
    
    public Account a;
    public Contact c;
     
    public TestOcdlaApplicationSettings(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        // this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        // this.c = [SELECT Id, FirstName, LastName, AccountId, Email FROM Contact WHERE Name LIKE :filter LIMIT 1];
    }
      
     
    @testSetup static void setup() {
        testSetup();
    } 
     
    public static void testSetup(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        // ClickpdxCore.TestBase.setup(recordPrefix);        
    }

    
    testMethod static void customStoreProductActions(){
        Test.startTest();
        OcdlaCustomStoreProductActions s = new OcdlaCustomStoreProductActions();
        OcdlaCustomStoreProductActions.setProductQuery();
        Test.stopTest();
    }
    
    testMethod static void customOrderEntrySaveableInit(){
        OcdlaCustomOrderEntrySave s = new OcdlaCustomOrderEntrySave();
        List<Map<String,String>> post = new List<Map<String,String>>();
        Map<String,String> foobar = new Map<String,String>();
        post.add(foobar);
        Test.startTest();
		// s.updateOrderLines(SObject order, Map<Id,OrderItem> original, Map<String,OrderItem> newLines, List<Map<String,String>> post){
		s.updateOrderLines(new Order(), null, null, post);
            
        Test.stopTest();
    }
    
    testMethod static void customRemoteObjectTemplate(){
        Test.startTest();
        
        Test.setCurrentPage(Page.RemoteObjectTemplateOrder);

        Test.stopTest();
    }
    
    testMethod static void ocdlaSubscriptionCalloutInit() {
		TestOcdlaApplicationSettings context = new TestOcdlaApplicationSettings();
         
         Test.startTest();
        /*
        OrgOcdlaHttpSendable callout = new OrgOcdlaHttpSendable();
        callout.setParams(new Map<String,String>{'foo'=>'bar'});
        callout.getParams();
        callout.getProtocol();
        callout.getDomain();
        callout.getEndpoint();
        
        HttpResponse res = new HttpResponse();
        callout.formatResponse(res);
        */
        Test.stopTest();
    }
    
    
    testMethod static void ocdlaApplicationSettingsInit() {
		TestOcdlaApplicationSettings context = new TestOcdlaApplicationSettings();
         
         Test.startTest();
        OcdlaApplicationSettings prodSettings = new OcdlaApplicationSettings();
        OcdlaSandboxApplicationSettings sandboxSettings = new OcdlaSandboxApplicationSettings();

        Test.stopTest();
    } 
    
    
    testMethod static void ocdlaPagesInit() {
		TestOcdlaApplicationSettings context = new TestOcdlaApplicationSettings();
         
         Test.startTest();

        // List of custom pages here; especially any Page Templates for
        // Remote Object definitions.
        // Test.setCurrentPage(Page.FdliPageTemplateOneColumn);
        
        Test.stopTest();
    } 
}