public class SandboxCommunityUser {
    
    
    // User record.
    protected User cu;
    
    protected Boolean hasCommunityLicense;
    
    protected User AccountOwner;
    
    private Boolean doDml = True;
    
	List<Profile> availableProfiles;
    
    
    
    public SandboxCommunityUser(User AccountOwner) {  
        
        this.AccountOwner = AccountOwner;
        User customerCommunityUser;
        this.hasCommunityLicense = True;
        
        if(Test.isRunningTest()){
            List<Profile> profiles = [SELECT Id, Name, UserType FROM Profile];
            
            System.debug('XX PROFILES XX');
            System.debug(profiles);
            
        }
        
        
        
        
        //CspLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        // Set<String> customerUserTypes = new Set<String> {'Fonteva Customer Community Login User'};
        
        
        
        availableProfiles = [SELECT Id FROM Profile WHERE Name='MN Customer Community Login User'];
        
        if(availableProfiles.size() > 0){
            // throw new CustomUserException('Found a Fonteva Profile on the scratch org.');
        }
        
        if(null == availableProfiles || availableProfiles.size() < 1) {
            availableProfiles = [SELECT Id FROM Profile WHERE Name='Authenticated Website'];
        }
        
        try {
        	customerCommunityUser = [SELECT Id, ProfileId, FirstName, LastName, Email, Username, Title, Alias FROM User WHERE IsActive = True AND Username= 'interns-customer1@ocdla.org' LIMIT 1];
            
            this.doDml = False;
            
        } catch(Exception e) {
            // Create community User
			customerCommunityUser = createCustomerSObject();
        }
        
        this.cu = customerCommunityUser;
    }
    
    public User createCustomerSObject() {
    
        return new User(  
            ProfileId = this.availableProfiles[0].Id,
            FirstName = 'Intern',  
            LastName = 'OCDLA',  
            Email = 'interns@ocdla.org',  
            Username = 'interns-customer1@ocdla.org',  
            Title = 'Title',  
            Alias = 'internc1',  
            TimeZoneSidKey = 'America/Los_Angeles',  
            EmailEncodingKey = 'UTF-8',  
            LanguageLocaleKey = 'en_US',  
            LocaleSidKey = 'en_US'
        );  
    }
    
    
    public void setRelatedContactId(Id contactId) {
        if(this.hasCommunityLicense) this.cu.ContactId = contactId;
    }
    
    
    public SObject insertSObject() {
        
        if(this.doDml) {
        	insert this.cu;
        }   
        
        return this.cu;
    }
    
    
}