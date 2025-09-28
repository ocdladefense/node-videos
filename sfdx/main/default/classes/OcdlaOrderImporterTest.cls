@isTest(SeeAllData=true)
public class OcdlaOrderImporterTest {
        

    
    private static testMethod void convertSalesOrderLines(){
        //OcdlaOrderImporterTest context = new OcdlaOrderImporterTest();
      	PricebookEntry entry = [SELECT Id FROM PricebookEntry WHERE Product2.Name = 'Books Online Subscription' LIMIT 1];
        
        Test.startTest();

        OcdlaOrderImporter theTest = new OcdlaOrderImporter();
        theTest.saveOrders();
        theTest.saveOrderItems(entry.Id);
        
        Test.stopTest();
    }
    
    private static testMethod void deleteConvertedOrders(){
        
        
        Test.startTest();

        OcdlaOrderImporter theTest = new OcdlaOrderImporter();
        theTest.deleteImportedOrders();
        theTest.deleteImportedOrderItems();
        
        Test.stopTest();
        
    }

}