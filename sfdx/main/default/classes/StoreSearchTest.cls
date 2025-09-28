@isTest
public class StoreSearchTest {

    
    
    testMethod static void doSearch(){
        Test.startTest();
        
        StoreSearch controller = new StoreSearch();
        StoreSearch.GetQueryResults(new String[]{'Laminate'});
        
        Test.stopTest();
    }
    
}