@isTest
private class CommunityTemplateControllerTests {
  
     
	@isTest
    private static void loadTemplateController() {
         
        PageReference thePage;
        CommunityTemplateController controller;
        String loginUrl;
        
        // Prepare our example page with at least one parameter.
        //  Facilitates test of 
        thePage = Page.Default;
        thePage.getParameters().put('id','someId');  
        
        Test.setCurrentPage(thePage);
        
        controller = new CommunityTemplateController();
    	controller.getProfileUrl();
        controller.getLogoutUrl();
        CommunityTemplateController.getCommunityDomain();
        // CommunityTemplateController.getNavMenuHtml();
        // 
        Boolean isUserLoggedIn = controller.getIsUserLoggedIn();
        
        loginUrl = controller.getLoginURL();
        
        System.debug('Login URL is: ' + loginUrl);
    }   
}