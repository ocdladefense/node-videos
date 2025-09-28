@isTest
public class ClickpdxHttpRequestTest {
    
    public static String usernameResetUrl = 'username-update';
      
    testMethod static void testInitHttpRequest(){
        // The contact whose username we want to change.
        String contactId;
        
        // Our Http callout to reset an OCDLA username.
        ClickpdxHttpRequest req;
        
        // The response from the callout.
        HTTPResponse resp;
        
        // Setup some example username info.
        Map<String,String> usernameUpdate = new Map<String,String>();
        
        // The endpoint for the reset
        String url =  usernameResetUrl + '/'+ contactId;
        
        // Okay, here's the old username (not sure if we need it)
        // and the new username.
        usernameUpdate.put('oldUsername','jbernal.web.dev@gmail.com');
        usernameUpdate.put('newUsername','redderx@yahoo.com');
        
        req = new ClickpdxHttpRequest(url);
        
        req.setPostBody(usernameUpdate);
        
        resp = req.send();    
    }
    
    testMethod static void testExecuteUsernameChange(){
        ClickpdxTest tma = new ClickpdxTest();
        ClickpdxTest.initData();
        User theUser = ClickpdxTest.getPortalUser(ClickpdxTest.c);
        Test.startTest();
        ClickpdxHttpRequest.executeUsernameChange(theUser.ContactId, theUser.Username, 'redderx@yahoo.com');
        Test.stopTest();
    }
    
    testMethod static void testUsernameChangeTrigger(){
        User runAsUser = ClickpdxTest.getSystemUser();
        ClickpdxTest tma = new ClickpdxTest();        
            ClickpdxTest.initData();        
        
        System.runAs(new User(Id=UserInfo.getUserId())){

            Test.startTest();
            
            User theUser = ClickpdxTest.getPortalUser(ClickpdxTest.c);
            theUser.Username = 'foobar@ocdla.org';
            insert theUser;
            Test.stopTest();
        }
    }
    
    
}