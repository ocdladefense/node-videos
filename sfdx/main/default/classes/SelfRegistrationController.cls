/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public without sharing class SelfRegistrationController {

    
    
    public String firstName {get; set;}
    
    public String lastName {get; set;}
    
    public String email {get; set;}
    
    public String password {get; set {password = value == null ? value : value.trim(); } }
    
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    
    public String token {get; set;}
    
    @testVisible
    private static Boolean checkBots = True;
    
    private static final Decimal HUMAN_THRESHOLD_SCORE = 0.5;
    
    
    
    public SelfRegistrationController() {}
    
    @testVisible
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    
      
    
    public Boolean isBot(String token) { 
        
        GoogleRecaptchaClient client = new GoogleRecaptchaClient();
        
        Decimal score = client.getScore(token);
        System.debug('SCORE IS: '+score);
        return score < HUMAN_THRESHOLD_SCORE;
    }
  

    public PageReference doAction() {
        OcdlaCommunityTemplateController.disableScripts();
        return null;
    }
    
    @testVisible
    private static Contact getExistingContact(String email){

        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Email = :email];
        
        return null != contacts && contacts.size() > 0 ? contacts[0] : null;
    }
    
    
    

    
    
    
    public PageReference registerUser() {
    
        try {
            // if(True) throw new SelfRegistrationControllerException('foobar');
            if (checkBots && isBot(this.token)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Sorry, no bots allowed.'); 
                ApexPages.addMessage(msg);
                return null;
            }  
            
               // it's okay if password is null - we'll send the user a random password in that case
            if (!isValidPassword()) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
                ApexPages.addMessage(msg);
                return null;
            }

        } catch(Exception e) {
            System.debug(e);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }
        


        String profileId = null; // To be filled in by customer.
        String roleEnum = null; // To be filled in by customer.
        String accountId = ''; // To be filled in by customer.
        
        String userName = email;

        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = communityNickname;
		u.ProfileId = profileId;
        
    
        
        Contact existingContact = getExistingContact(userName);
        if(null == existingContact) {
			existingContact = new Contact(FirstName = u.FirstName, LastName = u.LastName, Email = u.Username);
            insert existingContact;
            
            existingContact = [SELECT Id, FirstName, LastName, Email, AccountId, Ocdla_Is_Expert_Witness__c FROM Contact WHERE Id = :existingContact.Id];
        } 
        
        // Consult params['contactId'] to see if we're dealing with an existing Contact.
        // Code here prevents duplicate Contacts with the same email from being inserted into the database.
        //  (We want to avoid these kinds of duplicates.)
        u.ContactId = null != existingContact ? existingContact.Id : null;
        
        
    
        // Give ISelfRegister classes one final chance to update the accountId to be associated with any new Contact/User.
        //  Otherwise the default Salesforce behavior is enforced.  
        //   NOTE: if neither a default Account nor Person accounts are enabled the default Salesforce behavior is to throw a very
        //    generic error message.
        accountId = null != existingContact ? existingContact.AccountId : null;
        

    

        
        
        
        String userId = Site.createPortalUser(u, accountId, password);
      
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(userName, password, ApexPages.currentPage().getParameters().get('startURL'));
            }
            else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }
    
    

 

    private class SelfRegistrationControllerException extends Exception {}   
}