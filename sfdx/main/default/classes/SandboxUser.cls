public without sharing class SandboxUser {

    

    
    public User targetUser;
    
	public UserRole portalRole;
    

    public SandboxUser(String firstName, String lastName, String username) {
        this(firstName,lastName,username,username);
    }    
    public SandboxUser(String firstName, String lastName, String username, String email) {
        
          
        try {
            targetUser = [SELECT Id, UserRoleId, ProfileId, Username, Alias, Email, FirstName, LastName FROM User WHERE IsActive = True AND Username = :username LIMIT 1];
        } catch(Exception e ) {
        
			targetUser = createSObject(firstName, lastName, username, username);
        }
    }
    
    
    public void setUserRole(UserRole theRole) {
    
        this.targetUser.UserRoleId = theRole.Id;
    }
    
    
    
    public void setProfile(Profile theProfile) {
        
        this.targetUser.ProfileId = theProfile.Id; 
    }
    
    public void setRelatedContactId(Id contactId) {
        this.targetUser.ContactId = contactId;
    }
    
    public void setLinkedCustomerUser(User customerUser) {
        this.targetUser.LinkedCustomerUser__c = customerUser.Id;
    }
    

    
    public static String generateUsername(String localPart, String domain) {
        
        String adhoc = String.valueOf(System.currentTimeMillis());
        adhoc = adhoc.substring(adhoc.length()-4);
        String username = localPart + '-' + adhoc + '@' + domain;
        
        return username;
    }
    
    public User createSObject(String firstName, String lastName, String username, String email) {

        String adhoc = String.valueOf(System.currentTimeMillis());
        String alias = adhoc.substring(0,4);
        
        return new User(  
            Username = username,
            Alias = 'int' + alias,
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            LanguageLocaleKey = 'en_US',  
            LocaleSidKey = 'en_US',  
            EmailEncodingKey = 'UTF-8',  
            TimeZoneSidKey = 'America/Los_Angeles'  
        );  

    }
    
    
    public User getSObject() {
        return this.targetUser;
    }
    
    
    public User insertSObject() {

        if(null == targetUser.Id) {
        	insert targetUser;
        }  else {
            update targetUser;
        }

        return targetUser;
    }
    
}