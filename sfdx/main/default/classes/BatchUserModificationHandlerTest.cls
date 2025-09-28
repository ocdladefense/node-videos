@isTest
public class BatchUserModificationHandlerTest {
    
    @testSetup
    private static void setup(){
        
        
        
        Id profileId = [SELECT Id, Name FROM Profile where Name = 'Customer Community Login User'].Id;
        
        Account ac = new Account(name ='TestAccount') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='Testing', email = 'example@qq.com', AccountId = ac.Id);
        insert con;  
        
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        User u = new User(Alias = 'standt', Email='test@exampleqq.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, IsActive = True, ContactId = con.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='test@exampleqq.com');
        
        System.runAs (thisUser) {
            insert u;
        }
        
    }
    
    
    
    @isTest
    private static void testBatch() {
        
        Test.startTest();
        BatchUserModificationHandler tba = new BatchUserModificationHandler(5);
        
        Id jobid = Database.executeBatch(tba,5);
        Test.stopTest();
    }
    
    
    @isTest
    private static void testDisableUser(){
        
        BatchUserModificationHandler handler = new BatchUserModificationHandler();
        
        List<User> users = [SELECT Id, Name, Email, IsActive, IsPortalEnabled FROM User WHERE Email LIKE '%qq.com%' AND IsActive = True LIMIT 5];
        
        List<User> disabledUsers = handler.deactivateUsers(users);
        
        System.runAs (new User(Id = UserInfo.getUserId())) {
            update disabledUsers;
        }
    }
}