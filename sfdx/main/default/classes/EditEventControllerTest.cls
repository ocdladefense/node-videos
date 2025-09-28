@isTest
public class EditEventControllerTest {

    @testSetup
    private static void doTestSetup() {
        
        Event__c theEvent = new Event__c();
        theEvent.Name = 'The Upcoming Event';
        theEvent.Start_Date__c = Date.newInstance(2050, 1, 1);
        
        insert theEvent;
    }
    
    @isTest
    private static void doTest() {
        
        Event__c theEvent = [SELECT Id, Agenda__c FROM Event__c LIMIT 1];
        
        
        PageReference thePage = Page.EventAgenda;
        Map<String,String> params = thePage.getParameters();
        params.put('id', theEvent.Id);
        
        Test.setCurrentPage(thePage);

        EditEventController con = new EditEventController();
        con.doSubmit();
        con.doCancel();
    }
    
}