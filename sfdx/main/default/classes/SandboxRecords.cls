global without sharing class SandboxRecords implements Database.Batchable<Contact> {
    
    

    
    
    global void doWork() {
        
        
        User portalAccountOwner;
        Contact customerContact;
        Id customerContactId;
        Account guestCheckoutAccount;
        Account portalAccount;
        
        portalAccountOwner = SandboxEnvironment.getSystemAdministrator();
        
        // Create the guest checkout account.
        String GUEST_CHECKOUT_ACCOUNT_NAME = 'Guest Checkout Account';
        String PORTAL_ACCOUNT_NAME = 'OCDLA Intern Account';
        
        List<Account> existing = [SELECT Id, Name FROM Account WHERE Name = :GUEST_CHECKOUT_ACCOUNT_NAME];
        guestCheckoutAccount = existing.size() > 0 ? existing[0] : new Account(Name=GUEST_CHECKOUT_ACCOUNT_NAME);
        
        upsert guestCheckoutAccount;
        
        existing = [SELECT Id, Name FROM Account WHERE Name = :PORTAL_ACCOUNT_NAME];
        portalAccount = existing.size() > 0 ? existing[0] : new Account(Name = PORTAL_ACCOUNT_NAME, OwnerId = portalAccountOwner.Id);
        
        upsert portalAccount;
        
        customerContact = new Contact(LastName = 'Intern', FirstName='OCDLA', Email='interns@ocdla.org');
        customerContact.AuthorizeDotNetCustomerProfileId__c = '905372692';
        customerContact.AccountId = portalAccount.Id;
        
        insert customerContact;
    }
    
    
    global System.Iterable<Contact> start(Database.BatchableContext ctx)  {
        
        
        Contact c = new Contact(FirstName='Jose',LastName='Bernal',Email='jbernal.web.dev@gmail.com');
        return new List<Contact>{c};
    }
    
    
    global void execute(Database.BatchableContext SC, List<Contact> rexords) {
        this.doWork();
    }
    
    global void finish(Database.BatchableContext SC) {
        // sthis.doWork();
    }
}