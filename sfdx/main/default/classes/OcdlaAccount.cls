global class OcdlaAccount {
	public static final Integer ACCOUNT_QUERY_CURRENT_MEMBER_CONTACTS = 1;
    
    public static final Integer ACCOUNT_QUERY_ALL_CONTACTS = 2;
    

    public static List<Contact> getAccountContacts(Id AccountId, Integer queryType){
        // Determine whether the list of Contacts
        // should be constrained to Current Members.
        Boolean currentMembersOnly;
        
        return getAccountContacts(AccountId,queryType == ACCOUNT_QUERY_CURRENT_MEMBER_CONTACTS,null);
    }
    
    public static List<Contact> getAccountContacts(Id AccountId, Boolean currentMembersOnly){
        return getAccountContacts(AccountId,currentMembersOnly,null);
    }
     
    @future 
    public static void UpdateContactUsername(Id ContactId, String Username) {
        System.debug('(Future) Method UpdateContactUsername called with: '+ContactId);
        List<Contact> contacts = [SELECT Id, Ocdla_Username__c FROM Contact WHERE Id=:ContactId];
        if(contacts.size()>0) {
            contacts[0].Ocdla_Username__c = Username;
            update contacts[0];
        }
    }
    
    // SELECT all Contacts for an account
    public static List<Contact> getAccountContacts(Id AccountId, Boolean currentMembersOnly, Date expiration){
        List<Contact> theContacts;
        if(currentMembersOnly && null!=expiration){
    	theContacts = [SELECT Id, FirstName, LastName, Ocdla_Bar_Year__c,
                                     Ocdla_Member_Status__c, Ocdla_Bar_Number__c,
                                     OrderApi__Work_Email__c,Ocdla_Current_Member_Flag__c FROM Contact
                                     WHERE AccountId = :AccountId AND 
                       Ocdla_Current_Member_Flag__c=True AND Ocdla_Membership_Expiration_Date__c = :expiration
                      ORDER BY LastName];
        } else if(currentMembersOnly){
    	theContacts = [SELECT Id, FirstName, LastName, Ocdla_Bar_Year__c,
                                     Ocdla_Member_Status__c, Ocdla_Bar_Number__c,
                                     OrderApi__Work_Email__c,Ocdla_Current_Member_Flag__c FROM Contact
                                     WHERE AccountId = :AccountId AND 
                       Ocdla_Current_Member_Flag__c=True
                      ORDER BY LastName]; 
        } else {
    	theContacts = [SELECT Id, FirstName, LastName, Ocdla_Bar_Year__c,
                                     Ocdla_Member_Status__c,Ocdla_Current_Member_Flag__c, Ocdla_Bar_Number__c,
                                     OrderApi__Work_Email__c FROM Contact
                                     WHERE AccountId = :AccountId ORDER BY LastName];   
        }
        return theContacts;
    }
}