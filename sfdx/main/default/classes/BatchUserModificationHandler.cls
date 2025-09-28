public class BatchUserModificationHandler implements Database.Batchable<User> {
    
    
    public final Integer theLimit {get; set;}
    
    
    public BatchUserModificationHandler(){}
    
    public BatchUserModificationHandler(Integer myLimit){
        theLimit = myLimit;
    }
    
    
    public List<User> deactivateUsers(List<User> users){
        
        for(User user : users){
            
            user.IsActive = False;
            user.IsPortalEnabled = False;
        }
        
        return users;
    }
    
    public void execute(Database.BatchableContext jobId, List<User> records) {
        
        if(Test.isRunningTest()){
            System.runAs(new User(Id=UserInfo.getUserId())) {
                update this.deactivateUsers(records);        
            }
        } else {
            update this.deactivateUsers(records);
        }

    }

/*    
    @future
    public static void deleteContacts(){
	
        List<Contact> contacts = [SELECT Id, AccountId, Name FROM Contact WHERE email LIKE '%qq.com%'];
        delete contacts;
    
    }
*/
    
    public void finish(Database.BatchableContext jobId) {
        

    }
    
    public List<User> start(Database.BatchableContext jobId){
        
        if(null != theLimit) {
            System.debug(theLimit);
            String theFormat = 'SELECT Id, Name, Email, IsActive FROM User WHERE Email LIKE \'%{0}%\' AND (IsActive = True OR IsPortalEnabled = True) LIMIT {1}';
            String queryString = String.format(theFormat, new Object[]{'qq.com',theLimit});
            return Database.query(queryString);
        } else {
            return [SELECT Id, Name, Email, IsActive FROM User WHERE Email LIKE '%qq.com%' AND (IsActive = True OR IsPortalEnabled = True)];
        }

    }

	
}