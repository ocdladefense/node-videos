global without sharing class SandboxMixedDml implements Database.Batchable<Contact> {

    
    global String sandboxName;
    
    global Id contactId;
    
    
    public void doWork() {    
    
        if(null == this.contactId) {
            
            List<Contact> candidates = [SELECT Id FROM Contact WHERE LastName = 'Intern'];
            this.contactId = null != candidates && candidates.size() > 0 ? candidates[0].Id : null;
        }

		// SandboxRecords.createSandboxPortalAccountOwner();
        SandboxUserRole r1 = new SandboxUserRole();
        UserRole theRole = r1.insertSObject();
        
        // Make sure usernames are unique.
        String ownerUsername = 'interns@ocdla.org.'+this.sandboxName;
        String customerUsername = SandboxUser.generateUsername('intern-customer','ocdla.org.'+this.sandboxName);
        
        System.debug(theRole);
		Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        SandboxUser owner = new SandboxUser('Intern', 'Admin', ownerUsername);
        owner.setUserRole(theRole);
        owner.setProfile(sysAdminProfile);
        
        User portalAccountOwner;
        
        try {
            portalAccountOwner = owner.insertSObject();
        } catch(System.DmlException e) {
            System.debug('USER_INITIALIZATION_ERROR: [Username='+ownerUsername+']');
            throw e;
        }
        
        if(null != this.contactId) {

            SandboxUser customer = new SandboxUser('Intern', 'Customer', customerUsername);
            customer.setRelatedContactId(this.contactId);
            customer.setProfile(SandboxEnvironment.getCustomerProfile());
            
            User record = customer.insertSObject();
            
            owner.setLinkedCustomerUser(customer.getSObject());
			owner.insertSObject();
        }
	}   
    
    public SandboxMixedDml(String sandboxName) {
        this(null,sandboxName);
    }
    public SandboxMixedDml(Id contactId, String sandboxName) {
        this.contactId = contactId;
        this.sandboxName = sandboxName;
    }
    
    
    global System.Iterable<Contact> start(Database.BatchableContext ctx)  {
        
        
        Contact c = new Contact(FirstName='Jose',LastName='Bernal',Email='jbernal.web.dev@gmail.com');
        return new List<Contact>{c};
    }
    
    
    global void execute(Database.BatchableContext SC, List<Contact> records) {
        this.doWork();
    }
    
    global void finish(Database.BatchableContext SC) {
        // sthis.doWork();
    }
}