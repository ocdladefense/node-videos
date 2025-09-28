global without sharing class OcdlaSubscriptionList {

    /*
    public static Map<Id,List<OrderApi__Subscription__c>> getContactSubscriptions(List<Id> theContactIds){
        System.debug('Entering method getContactSubscriptions...');
        List<OrderApi__Subscription__c> theSubscriptions = [SELECT Id,Name,OrderApi__Item__c FROM OrderApi__Subscription__c WHERE OrderApi__Contact__c IN :theContactIds];
        System.debug('Exiting method getContactSubscriptions...');        
    }
	*/
    public static List<OrderApi__Subscription__c> getMostRecentSubscriptionsAll(Set<Id> contactIds){
        System.debug('Entering method getMostRecentSubscriptionsAll...');
        // R
        // N
        // H
        // S
        // LL
        // A
        // L
        // C
        // X
        List<OrderApi__Subscription__c> theSubscriptions = [SELECT OrderApi__Contact__c, OrderApi__Item__c,
                                                         OrderApi__Is_Cancelled__c,
                                                            OrderApi__Is_Suspended__c,
                                                            OrderApi__Current_Term_End_Date__c
                                                     FROM OrderApi__Subscription__c
                                                    WHERE OrderApi__Contact__c IN :contactIds 
                                                    ORDER BY OrderApi__Contact__c,
                                                  OrderApi__Current_Term_End_Date__c DESC];
        System.debug(theSubscriptions);
        return theSubscriptions;
    }
    
    public static void calculateContactMembershipStatus(Set<Id> contactIds){
        
        List<OrderApi__Subscription__c> theSubscriptions = OcdlaSubscriptionList.getMostRecentSubscriptionsAll(contactIds);
        // Here, create a new method that retrieves a List of Items (List<OrderApi__Item__c>)
        // Based on the AggregateResult List
        // List<OrderApi__Item__c> = OcdlaStoreItems.getItemObjects()
        Map<Id,OrderApi__Item__c> relatedItems = OcdlaSubscriptionList.getRelatedItems(theSubscriptions);
        
   		// When iterating through the List, if using a Set, only the most recent 
   		// Subscription will be added to the Set by virtue of the unique definition of a Set
   		// using the corresponding Contacts.
        Set<Contact> contactsToUpsert = new Set<Contact>();
        // Comparison set containing only the Id
        Set<Contact> contactsForComparison = new Set<Contact>();
        for(OrderApi__Subscription__c sub: theSubscriptions){
            Boolean isRemoved = sub.OrderApi__Is_Suspended__c || sub.OrderApi__Is_Cancelled__c;
            String reason = sub.OrderApi__Is_Suspended__c ? 'Subscription suspended by '+UserInfo.getUserName()+'.' : '';
            reason = sub.OrderApi__Is_Cancelled__c ? 'Subscription cancelled by '+UserInfo.getUsername()+'.' : reason;
            
            Contact theContact = new Contact();
            theContact.Id = sub.OrderApi__Contact__c;
            
            Contact theContactComp = new Contact();
            theContactComp.Id = sub.OrderApi__Contact__c;
            
            // Do not process duplicate Contacts resulting from a previous Contact's Subscriptions
            if(contactsForComparison.contains(theContactComp)) continue;
            contactsForComparison.add(theContactComp);
            
            // As opposed to the Ocdla_Current_Member_Flag__c, which is a calculated field.
            // theContact.Ocdla_Current_Member__c = True;
            
            // NOFLAG, documented here for reference
            // theContact.Ocdla_Noflag__c = False;

            // End Date, currently no end date field on the Contact object
			theContact.Ocdla_Membership_Expiration_Date__c = sub.OrderApi__Current_Term_End_Date__c;
            
            // Member's status code, i.e., R, N, L, etc.
            theContact.Ocdla_Member_Status__c = relatedItems.get(sub.OrderApi__Item__c).Ocdla_Subscription_Membership_Status__c;
            
            if(isRemoved){
                theContact.Ocdla_Membership_Removed__c = isRemoved;
                theContact.Ocdla_Membership_Removed_Reason__c = reason;
            }
            contactsToUpsert.add(theContact);
        }      
        upsert (new List<Contact>(contactsToUpsert));
    }
    
    public static Map<Id,OrderApi__Item__c> getRelatedItems(List<OrderApi__Subscription__c> theResults){
        Set<Id> itemIds = new Set<Id>();
        for(OrderApi__Subscription__c r:theResults){
            itemIds.add(r.OrderApi__Item__c);
        }
        List<OrderApi__Item__c> results = [SELECT Id, Name, Ocdla_Subscription_Membership_Status__c FROM OrderApi__Item__c WHERE Id IN :itemIds];
        return new Map<Id,OrderApi__Item__c>(results);
    }
    
    public static OrderApi__Subscription__c getMostRecentSubscription(Id theContactId){
        System.debug('Entering method getMostRecentSubscription...');
        // R
        // N
        // H
        // S
        // LL
        // A
        // L
        // C
        // X
   
        OrderApi__Subscription__c theSubscription = [SELECT Id, OrderApi__Item__c, 
                                                     Ocdla_New_or_Renewed__c, Ocdla_Member_Status__c, 
                                                     OrderApi__Current_Term_End_Date__c, OrderApi__Subscription_Plan__c 
                                                     FROM OrderApi__Subscription__c 
                                                     WHERE OrderApi__Contact__c=:theContactId ORDER BY OrderApi__Current_Term_End_Date__c DESC LIMIT 1];
        System.debug(theSubscription);
        System.debug('Exiting method getMostRecentSubscription...');      
        return theSubscription;
    }
    
}