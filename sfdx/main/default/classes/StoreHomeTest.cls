@isTest
public class StoreHomeTest {


    public StoreHomeTest(){
        
    }
    
    static testMethod void loadHomepage() {

        Test.startTest();
        StoreHome controller = new StoreHome();
        Test.setCurrentPage(Page.StoreHome);

        
        Test.stopTest();
    }
    
    
}