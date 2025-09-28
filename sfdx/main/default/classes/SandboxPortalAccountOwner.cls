public without sharing class SandboxPortalAccountOwner {

    

    
    public User AccountOwner;
    
	public UserRole portalRole;
    
    
    public SandboxPortalAccountOwner(UserRole pr) {
        this.portalRole = pr;


        System.debug('portalRole is ' + this.portalRole);  
        
        
       

		User portalAccountOwner;
        
        try {
            portalAccountOwner = [SELECT Id, UserRoleId, ProfileId, Username, Alias, Email, FirstName, LastName FROM User WHERE IsActive = True AND Username = 'interns@ocdla.org' LIMIT 1];
        } catch(Exception e ) {
        
			portalAccountOwner = createPortalAccountOwnerSObject();
            
        }
       
        AccountOwner = portalAccountOwner;
    }  
    
    public User createPortalAccountOwnerSObject() {
        
		 Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];  
        
        return  new User(  
                UserRoleId = this.portalRole.Id,  
                ProfileId = sysAdminProfile.Id,  
                Username = 'interns@ocdla.org',//portalOwner' + System.currentTimeMillis() + '@test.com',  
                Alias = 'interns9',  
                Email='interns@ocdla.org',  
                EmailEncodingKey='UTF-8',  
                Firstname='Portal',  
                Lastname='Owner',  
                LanguageLocaleKey='en_US',  
                LocaleSidKey='en_US',  
                TimeZoneSidKey = 'America/Los_Angeles'  
            );  
    }
    
    
    public User insertSObject() {

        if(null == AccountOwner.Id) {
        	insert AccountOwner;
        }  else {
            update AccountOwner;
        }

        return AccountOwner;
    }
    
}