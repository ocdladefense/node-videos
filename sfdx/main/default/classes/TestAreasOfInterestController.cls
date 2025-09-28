@isTest
private class TestAreasOfInterestController {

    
    /**
     * Insert a Contact and some Areas of Interest for the Contact.
     */
    @testSetup 
    private static void setup() {
       Contact c = new Contact(LastName = 'Smith');
       insert c;
        
       AreaOfInterest__c aoi_1 = new AreaOfInterest__c(Contact__c = c.Id, Interest__c='Discovery');
       AreaOfInterest__c aoi_2 = new AreaOfInterest__c(Contact__c = c.Id, Interest__c='Arson');
       
       insert new AreaOfInterest__c[]{aoi_1,aoi_2};
       
    }  
    
    
    @isTest
    private static void testPage() {
        
        Contact c = [SELECT Id FROM Contact WHERE LastName='Smith' LIMIT 1];
        
        PageReference thePage = Page.ProfileAreasOfInterest;
        thePage.getParameters().put('id',c.Id);
        Test.setCurrentPage(thePage);
        
		// ApexPages.StandardController sc = new ApexPages.StandardController(c);
        AreasOfInterestController ctr = new AreasOfInterestController();
        

        ctr.addRow();
        
        ctr = new AreasOfInterestController();
        ctr.addRow('Arson');
        thePage.getParameters().put('rowIndex','0');
        ctr.deleteRow();
        ctr.save();
    }
}