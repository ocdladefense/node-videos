public class BatchDeleteContact implements Database.Batchable<Contact> {
    
        
    
    public final Integer theLimit {get; set;}
    
    public final Date theThreshold {get; set;}
    
    
    public BatchDeleteContact(){}
    
    public BatchDeleteContact(Integer myLimit, Date myThreshold){
        theLimit = myLimit;
        theThreshold = myThreshold;
    }



    
    public void execute(Database.BatchableContext jobId, List<Contact> records) {
        
        
        delete records;


    }
    
    public void finish(Database.BatchableContext jobId) {}
    
    public List<Contact> start(Database.BatchableContext jobId){
          
        // retrieves the entire set of records that are going to be batched.
        
        
        // Buld the list of 'qq.com' user emails.
        // Date foobar = Date.newInstance(2022,1,1);
        List<User> users;
        List<String> emails = new List<String>();
        
        try {
            if(null != theLimit) {
                users = [SELECT Id, Email FROM User WHERE Email LIKE '%qq.com%' AND IsActive = False AND IsPortalEnabled = False AND CreatedDate >= :theThreshold];
            } else {
                users = [SELECT Id, Email FROM User WHERE Email LIKE '%qq.com%' AND IsActive = False AND IsPortalEnabled = False];            
            }
        } catch(System.LimitException e) {
             System.debug(e.getMessage());   
        }
        
        for(User user : users){
            emails.add(user.Email);
        }
        System.debug('IN BATCH');
        System.debug(emails);
        
        if(null != theLimit) {
            String theFormat = 'SELECT Id, Email FROM Contact WHERE Email IN :emails LIMIT {0}';
            String queryString = String.format(theFormat, new Object[]{theLimit});
            return Database.query(queryString);
        } else {
            return [SELECT Id, Email FROM Contact WHERE Email IN :emails];
        }

    }
    
    public class BatchDeleteException extends Exception {}

}