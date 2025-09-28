/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@isTest(SeeAllData=true)
private class SelfRegistrationControllerTest {
    
           
    @isTest(SeeAllData=true) 
    private static void noBotChecking() {
        SelfRegistrationController controller = new SelfRegistrationController();
        SelfRegistrationController.checkBots = False;
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.token = 'nochecktoken';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        
        SelfRegistrationController.checkBots = False;
        
        PageReference value = controller.registerUser();
        System.assert(null == value);
        
        Boolean validPassword = controller.isValidPassword();
    }
    
      
    
    @isTest(SeeAllData=true) 
    private static void testBotCheck() {
        SelfRegistrationController controller = new SelfRegistrationController();
        SelfRegistrationController.checkBots = True;
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.token = 'iamabot';	
        
        Test.startTest();
        
            // Should registerUser return null?
            GoogleRecaptchaMockResponse.scoreType = GoogleRecaptcha.ResponseScore.BOT;
            Test.setMock(HttpCalloutMock.class, new GoogleRecaptchaMockResponse());
            System.assert(controller.registerUser() == null);
        
        Test.stopTest();
    }
      
    
    
    
    @isTest(SeeAllData=true) 
    private static void humanShouldPass() {
        SelfRegistrationController controller = new SelfRegistrationController();
        SelfRegistrationController.checkBots = True;
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.token = 'iamhuman';	

        
        Test.startTest();
            GoogleRecaptchaMockResponse.scoreType = GoogleRecaptcha.ResponseScore.HUMAN;
            Test.setMock(HttpCalloutMock.class, new GoogleRecaptchaMockResponse());
        	controller.registerUser();
        Test.stopTest();
    }
    
    
    
    @isTest(SeeAllData=true) 
    private static void miscellaneous() {
        SelfRegistrationController controller = new SelfRegistrationController();
        
        Test.startTest();
            controller.doAction();
            SelfRegistrationController.getExistingContact('hello@abc.com');
        Test.stopTest();
    }
    
    
}