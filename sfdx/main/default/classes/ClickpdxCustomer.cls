public without sharing class ClickpdxCustomer {

    public static Contact getContact(String email){
        List<Contact> contacts = new List<Contact>();
        contacts.addAll([SELECT Id, Name FROM Contact WHERE Email = :email]);
        
        return contacts.size()>0 ? contacts[0] : null;
    }
     
    public static Boolean isCustomerCurrentMember(){
        Id userId; 
        User theUser;
        Contact theContact = new Contact(Id=null,FirstName='Sample',LastName='Contact');
        
        userId = UserInfo.getUserId();
        theUser = [SELECT Id, ContactId FROM User WHERE Id = :userId];
        
        if(null != theUser.ContactId){
            theContact = [SELECT Id, Name, Ocdla_Current_Member_Flag__c FROM Contact WHERE Id = :theUser.ContactId];
        }
        
        return (null != theContact.Id && theContact.Ocdla_Current_Member_Flag__c); 
    }
    
    public static Boolean isCurrentMemberEmail(String email){
        List<Contact> theContacts;
        
        theContacts = [SELECT Id, Name, Ocdla_Current_Member_Flag__c FROM Contact WHERE Email = :email];

        return (null != theContacts && 0 < theContacts.size() && theContacts[0].Ocdla_Current_Member_Flag__c); 
    }
}