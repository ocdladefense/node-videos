@isTest
public class FieldEditorTest {

    
    
    @testSetup
    private static void doTestSetup() {
          
        Event__c theEvent = new Event__c();
        theEvent.Name = 'The Upcoming Event';
        theEvent.Start_Date__c = Date.today();
        
        insert theEvent;
    }  
     
    
    
    @isTest
    private static void doTest() {
        
        
        Event__c theEvent = Database.query('SELECT Id, Agenda__c FROM Event__c LIMIT 1');
        
        
        PageReference thePage = Page.RichTextFieldEditor;
        FieldEditor con;
        
        Map<String,String> params = thePage.getParameters();
        params.put('id', theEvent.Id);
        params.put('fieldName', 'Agenda__c');
        
        Test.setCurrentPage(thePage);
		con = new FieldEditor();

        con.doSubmit();
        con.doCancel();
        
        FieldEditorException e = new FieldEditorException('There was an error.');
    }
    
}