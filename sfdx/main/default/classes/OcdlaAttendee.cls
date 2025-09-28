global without sharing class OcdlaAttendee {
    


/**
 * Update first and last names for any Event-related ticket purchases.
 * author: Jose Bernal
 * date: 
*/
    webservice static void doAutofillNames(Id eventId) {

        List<OrderItem> theItems;
        List<Id> contactIds = new List<Id>();
        Map<Id,Contact> theContacts = new Map<Id,Contact>();

        
        if(null == eventId){
            return;
        }
        
        theItems = [SELECT Id, Contact__c, FirstName__c, LastName__c, Note_1__c FROM OrderItem WHERE FirstName__c = null AND LastName__c = null
                    AND Contact__c != null AND OcdlaEventId__c = :eventId AND Note_1__c != 'omit'];
        
        
        for(OrderItem item :theItems){
            contactIds.add(item.Contact__c);
        }
        
        theContacts.putAll([SELECT Id, FirstName, LastName FROM Contact WHERE Id = :contactIds]);
        
        for(OrderItem item :theItems){
            item.FirstName__c = theContacts.get(item.Contact__c).FirstName;
            item.LastName__c = theContacts.get(item.Contact__c).LastName;
        }
        
        upsert theItems;
    }
    

    
}