@isTest
private class OcdlaEventToJsonTest {
    public static testMethod void testMyController() {
       
       
        EventApi__Event__c myEvent = new EventApi__Event__c(name = 'My Event');
        // insert myEvent;
    ApexPages.StandardController sc = new ApexPages.StandardController(myEvent);
         
       //Use the PageReference Apex class to instantiate a page
       PageReference pageRef = Page.Ocdla_Event;
       
       pageRef.getParameters().put('id', String.valueOf(myEvent.Id));
       Test.setCurrentPage(pageRef);
       
       //In this case, the Visualforce page named 'success' is the starting point of this test method. 
       // Test.setCurrentPage(pageRef);
            
       //Instantiate and construct the controller class.   
       OcdlaObjectToJson controller = new OcdlaObjectToJson(sc);

       //Example of calling an Action method. Same as calling any other Apex method. 
       //Normally this is executed by a user clicking a button or a link from the Visualforce
       //page, but in the test method, just test the action method the same as any 
       //other method by calling it directly. 

       //The .getURL will return the page url the Save() method returns.
       // String nextPage = controller.save().getUrl();

       //Check that the save() method returns the proper URL.
       // System.assertEquals('/apex/failure?error=noParam', nextPage);

       //Add parameters to page URL
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
    }
}