@isTest
private class OcdlaCommunityTemplateControllerTests {
  
      
	@isTest
    private static void loadTemplateController() {
        
        Test.setCurrentPage(Page.StoreHome);
        
        OcdlaCommunityTemplateController theTemplate = new OcdlaCommunityTemplateController();
    	OcdlaCommunityTemplateController.getMenu();
        OcdlaCommunityTemplateController.getMenuHtml();
        OcdlaCommunityTemplateController.getNavMenuHtml();
    }   
}