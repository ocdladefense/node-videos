@isTest
public class SignInControllerTests {

    
    
    @isTest
    private static void doTests() {
          
        SignInController controller = new SignInController();
        
        controller.doAction();
        controller.getEncodedSiteUrl();
        controller.getEncodedStartUrl();
        
        controller.username = 'test-user@abc.com';
        controller.password = 'test-password';
        controller.login();
        
        PageReference thepage;
        thePage = Page.SignIn;
        // thePage.getParameters().put('id','someId');  
        
        Test.setCurrentPage(thePage);
        
        thePage = Page.OcdlaPageTemplate;
        Test.setCurrentPage(thePage);
    }
}