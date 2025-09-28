@isTest
public class CustomMetadataUtilitiesTest {

    
	@isTest
    private static void testCustomMetadataTypeDeployment() {
        
        Map<String, Object> myMenu = new Map<String, Object>();
        myMenu.put('ClickpdxCore__Value__c', 'foobar');
        
        Test.startTest();
        	CustomMetadataUtilities.save('ClickpdxCore__CoreConfig.StoreMenu', 'Store Menu', myMenu);
        
        	CustomMetadataUtilities handler = new CustomMetadataUtilities();
        
	        // Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        	// CustomMetadataUtilities.deploy(mdContainer);
        
			handler.handleResultHelper(Metadata.DeployStatus.Succeeded);
        
        Test.stopTest();
    }
}