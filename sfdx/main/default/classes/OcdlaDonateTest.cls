@isTest
public class OcdlaDonateTest {
     
    static String recordPrefix = 'TEST002'; 
     
    private static final String MEMBERSHIP_SUBCATEGORY_OPERATOR = 'Membership';
    
    private static final String PRODUCT_OPTION_FLAG = 'Option';
    
    private static final String DONATION_PRODUCT_FAMILY = 'Donation Fund';
    
    public Account a;
    
    public Contact c;
    
    public Product2 fund;
    
    public PricebookEntry entry; 
    
    
    public OcdlaDonateTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];

        this.fund = [SELECT Id, Name, ProductCode FROM Product2 LIMIT 1];
        this.fund.Family = DONATION_PRODUCT_FAMILY;
        update this.fund;
            
        this.entry = [SELECT Id, UnitPrice, Product2.Family, Product2.Description, Product2.Id, Product2.Name FROM PricebookEntry 
                      WHERE Product2.Id = :this.fund.Id LIMIT 1];
    }
    
    @testSetup static void setup() {
        ClickpdxTest.setup(recordPrefix);
    }
    
    
    @isTest
    static void loadDonatePage() {
        
        OcdlaDonateTest context = new OcdlaDonateTest();

        OcdlaDonate controller = new OcdlaDonate();
        
        Test.setCurrentPage(Page.Donate);
        
        String fundsJson = controller.getDonationFunds();
        
        String today = controller.getToday();
        String sampleDate = controller.getSampleFirstPaymentDate();
        String nextSampleDate = controller.getSampleNextPaymentDate();

    }
    
}