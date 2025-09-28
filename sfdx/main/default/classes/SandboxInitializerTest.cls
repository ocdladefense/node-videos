@isTest
public class SandboxInitializerTest {
 
      
      
    
    @isTest
    private static void testSandboxInitializerMetadataDeployment() {
        
        // Insert logic here to create records of the objects that the class you’re testing
        // manipulates.
        
        Test.startTest();    
        

        //Execute test script with RunAsAutoProcUser set to true
        Test.testSandboxPostCopyScript(
            new SandboxInitializer(), UserInfo.getOrganizationId(),
            UserInfo.getOrganizationId(), UserInfo.getOrganizationName(), True);
        
        Test.stopTest();
        
        // Insert assert statements here to check that the records you created above have
        // the values you expect.
    } 
        
       
    @isTest
    private static void testInitializationException() {
        
        SandboxInitializationException ex = new SandboxInitializationException('Sandbox error.');
        String message = ex.getMessage();
    }
      
  
    
    
    @isTest
    private static void testSandboxEnvironment() {
        
		SandboxEnvironment.hasCommunityLicenses();
		SandboxEnvironment.getAvailableProfiles();
		SandboxEnvironment.getSystemAdministratorProfile();
        SandboxEnvironment.getCustomerProfile();
        SandboxEnvironment.getSystemAdministrator();
    }
      
    
    
    @isTest
    private static void testInsertRequiredRecords() {

		String sandboxName = 'MySandbox2';
        
        // The Portal Account Owner is a User record.
        User portalAccountOwner;
        
        // The Portal Account Owner must have a role.
        UserRole theRole;
        
		Profile sysAdminProfile = SandboxEnvironment.getSystemAdministratorProfile();
        
        String ownerUsername = 'interns@ocdla.org.'+sandboxName;
        
        String customerUsername = 'intern-customer@ocdla.org.'+sandboxName;
        
        
        
        System.runAs(new User(Id = UserInfo.getUserId())) {

            
            SandboxUserRole r1 = new SandboxUserRole('My Custom Role');
			r1.createSObject();
            theRole = r1.insertSObject();              
    
            
            SandboxUser pao = new SandboxUser('Portal', 'Owner', ownerUsername);
            pao.setUserRole(theRole);
            pao.createSObject('Portal', 'Owner', ownerUsername, 'interns@ocdla.org'); // in case this doesn't get called implicitly.
            pao.setProfile(sysAdminProfile);  
            
            portalAccountOwner = pao.insertSObject();
        }
        
   
        Contact customerContact;
        Id customerContactId;
       	Account guestCheckoutAccount;
        Account portalAccount;

        // portalAccountOwner = SandboxEnvironment.getSystemAdministrator();
            
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
        
        System.runAs(portalAccountOwner) { 
            
            SandboxUser customer = new SandboxUser('Intern', 'Customer', customerUsername);
            customer.setProfile(SandboxEnvironment.getCustomerProfile());
            customer.setRelatedContactId(customerContact.Id);
			customer.createSObject('Intern', 'Customer', customerUsername,'interns@ocdla.org');
            
            User theUser = customer.insertSObject();
        }
    }

}