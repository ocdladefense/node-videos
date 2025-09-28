@isTest
public class BatchDeleteContactTest {
    
    
    
    private static void doSetup(Integer start) {        
        UserRole userrole = [SELECT Id, DeveloperName FROM UserRole WHERE Name = 'CEO' LIMIT 1];
        
        
        
        Id profileId = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Community Login User'].Id;
        
        User thisUser = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()]; 
        
        System.runAs(new User(Id=UserInfo.getUserId())) {
        	thisUser.UserRoleId = userrole.Id;
        	update thisUser;
        }
        System.debug('USERROLE' + userrole);
        
          
        
        System.runAs(thisUser){
            
            Account ac = new Account(name ='TestAccount'); /* moved line of code, in the example */
            insert ac;
            
            List<Contact> contacts = new List<Contact>();
            LIst<User> users = new List<User>();
            
            for(Integer i = start; i < start+15; i++){
                
                String theEmail = 'test' + i + '@qq.com';
                
                Contact c = new Contact(
                    AccountId = ac.Id, /* new line of code, in the example */
                    Email = theEmail,
                    LastName = 'Contact' + i);
                
                contacts.add(c);
            }
            
            insert contacts;
            
            
            for(Contact c : contacts){
                
                User u = new User(
                    IsActive = True,
                    ContactId = c.Id,
                    Email= c.Email, 
                    Username= c.Email,
                    Alias = 'standt',
                    EmailEncodingKey='UTF-8',
                    LastName= c.LastName,
                    LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US',
                    ProfileId = profileId,
                    TimeZoneSidKey='America/Los_Angeles'
                );
                System.debug(u);
                users.add(u);
            }
            
            
            insert users;
        }
        
    }
    
    
    @testSetup
    private static void setup(){
        doSetup(0);
    }
    
    
    
    
    @isTest
    private static void testBatch() {
        
        doSetup(15);
        

        BatchUserModificationHandler handler = new BatchUserModificationHandler();
        
        
        // Buld the list of 'qq.com' user emails.
        List<User> users = [SELECT Id, Username, Email, IsActive, IsPortalEnabled FROM User WHERE Email LIKE '%qq.com%' AND IsActive = True];
        System.debug(users);
        
        
        // Deactivate the users using the appropriate class.
        System.runAs(new User(Id=UserInfo.getUserId())) {
            update handler.deactivateUsers(users);
        }
        
          
        
        
        
        
        try {

            System.runAs(new User(Id=UserInfo.getUserId())) {
                Test.startTest();
                    Date myThreshold = Date.newInstance(2023,1,1);
                    Integer myLimit = 40;
                    BatchDeleteContact batch1 = new BatchDeleteContact(myLimit,myThreshold);
                    BatchDeleteContact batch2 = new BatchDeleteContact();
                
                Test.stopTest();
            }
        } catch(System.DmlException e) {
            
        }
        
    }
    
    
    
    
    @isTest
    private static void testBatchWithLimit() {
        
        doSetup(15);
        
        
        BatchUserModificationHandler handler = new BatchUserModificationHandler();
        
        
        // Buld the list of 'qq.com' user emails.
        List<User> users = [SELECT Id, Username, Email, IsActive, IsPortalEnabled FROM User WHERE Email LIKE '%qq.com%' AND IsActive = True];
        System.debug(users);
        
          
        // Deactivate the users using the appropriate class.
        System.runAs(new User(Id=UserInfo.getUserId())) {
            update handler.deactivateUsers(users);
        }
        
        
        
        try {
            
            Test.startTest();
            
            Date myThreshold = Date.newInstance(2022,1,1);
            Integer myLimit = 40;
            BatchDeleteContact batch1 = new BatchDeleteContact(myLimit,myThreshold);
            
            Id jobId1 = Database.executeBatch(batch1,40);
            
            Test.stopTest();
        } catch(System.DmlException e) {
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    @isTest
    private static void testDeleteContacts(){
        
        BatchUserModificationHandler handler = new BatchUserModificationHandler();
        
        
        // Buld the list of 'qq.com' user emails.
        List<User> users = [SELECT Id, Username, Email, IsActive, IsPortalEnabled FROM User WHERE Email LIKE '%qq.com%' AND IsActive = True];
        System.debug(users);
        
        
        // Deactivate the users using the appropriate class.
        System.runAs(new User(Id=UserInfo.getUserId())) {
            update handler.deactivateUsers(users);
        }
        System.debug(users);
        
        // Build the list of users again, this time the deactivated users.
        List<User> deactivated = [SELECT Id, Email FROM User WHERE Email LIKE '%qq.com%' AND IsActive = False LIMIT 100];
        System.debug(deactivated);
        
        List<String> emails = new List<String>();
        
        for(User user : users){
            
            emails.add(user.Email);
        } 
        
        System.debug(emails);
        
        
        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Email IN :emails];
        
        System.assert(contacts.size() > 0 && users.size() >= contacts.size(), 'The resulting contact list should have at least one element and the user list should be of reasonable length.');
        try {
            
            delete contacts;
            
        } catch (Exception e){
            
            System.debug(e.getMessage());
        }
        
        
    }
    
}