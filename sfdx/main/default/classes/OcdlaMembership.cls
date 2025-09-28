global class OcdlaMembership {

    /**
     * 
     * @method - renewMemberships
     * 
     * @description - Update the member statuses and member expiration dates for the 
     *   passed set of Contacts.
     * 
     */
    public static final Date MEMBERSHIP_RENEWAL_EXPIRATION = Date.newInstance(2026,6,30);
    
    public static final Date CAPDEF_RENEWAL_EXPIRATION = Date.newInstance(2026,6,30);
    
    
    
    private static Boolean isExpiredMembership(Date expiration){
        if(null == expiration) return True;
        return yearDifference(MEMBERSHIP_RENEWAL_EXPIRATION.year(), expiration.year()) > 1;
    }
    
    private static Boolean isExpiredCapitalDefender(Date expiration){
        return yearDifference(CAPDEF_RENEWAL_EXPIRATION.year(), expiration.year()) > 1;
    }
    
    private static Integer yearDifference(Integer year1, Integer year2){
        return year1 - year2;
    }
    
    @future
    public static void renewMemberships(Map<Id,String> contactsAndStatuses){
        if(null == contactsAndStatuses || contactsAndStatuses.size() == 0){
            return;
        }
        // @var - theContacts
        // @description - the list of Contacts that are to be updated.
        List<Contact> theContacts;
        
        
        theContacts = [SELECT Id, Ocdla_Member_Status__c, Ocdla_Membership_Expiration_Date__c FROM Contact WHERE Id = :contactsAndStatuses.keyset()];
        for(Contact c : theContacts){
            Date currentExpiration;
            Date newExpiration;
            
            currentExpiration = null == c.Ocdla_Membership_Expiration_Date__c ? MEMBERSHIP_RENEWAL_EXPIRATION : c.Ocdla_Membership_Expiration_Date__c;
            
            // Expired subscriptions of more than one year should be set to the renewal expiration.
            newExpiration = isExpiredMembership(currentExpiration) ? MEMBERSHIP_RENEWAL_EXPIRATION : currentExpiration.addYears(1);
            
            if(newExpiration > MEMBERSHIP_RENEWAL_EXPIRATION){
            	newExpiration = MEMBERSHIP_RENEWAL_EXPIRATION; 
            }
            
            // Run a check to determine if this user is a new member.
            // For example, do they have an existing membership status or expiration date?
            // If they DO NOT AND they are logged in then we should not give them a status.
            c.Ocdla_Membership_Expiration_Date__c = newExpiration;
            c.Ocdla_Member_Status__c = contactsAndStatuses.get(c.Id);
        }
		
        
        update theContacts;
    }

    @future    
    public static void renewCapitalDefenders(List<Id> theContactIds){
        if(null == theContactIds || theContactIds.size() == 0){
            return;
        }
        
        // @var - theContacts
        // @description - the list of Contacts that are to be updated.
        List<Contact> theContacts;
        
        
        theContacts = [SELECT Id, OcdlaCapitalDefendersExpiration__c FROM Contact WHERE Id = :theContactIds];
        
        for(Contact c : theContacts){
            Date currentExpiration;
            Date newExpiration;
            
            currentExpiration = c.OcdlaCapitalDefendersExpiration__c;
            
            // Expired subscriptions of more than one year should be set to the renewal expiration.
            newExpiration = isExpiredMembership(currentExpiration) || null == currentExpiration ? MEMBERSHIP_RENEWAL_EXPIRATION : currentExpiration.addYears(1);
            
            if(newExpiration > MEMBERSHIP_RENEWAL_EXPIRATION){
            	newExpiration = MEMBERSHIP_RENEWAL_EXPIRATION; 
            }
            
            c.OcdlaCapitalDefendersExpiration__c = newExpiration;
        }
		
        
        update theContacts;
    }
    
    webservice static Boolean evaluateMemberships(Id OrderId){
        Map<Id,String> renewals;
        
        renewals = getOrderItems(OrderId);
        
        if(null == renewals || renewals.size() == 0){
            return False;
        }
        
        renewMemberships(renewals);
        
        return True;
    }
    
    public static Map<Id,String> getOrderItems(Id OrderId){
        List<OrderItem> lines = new List<OrderItem>();
        Map<Id,String> contactMembershipStatuses = new Map<Id,String>();
        

        lines.addAll([SELECT Id, Product2.Id, Product2.OcdlaMembershipStatusGrant__c, Contact__c, FirstName__c, LastName__c, ExpirationDate__c FROM OrderItem WHERE OrderId = :OrderId]);

        
        
        for(OrderItem li : lines){
            if(null != li.Contact__c && null != li.Product2.OcdlaMembershipStatusGrant__c){
                contactMembershipStatuses.put(li.Contact__c,li.Product2.OcdlaMembershipStatusGrant__c);
            }
        }
        
        return contactMembershipStatuses;
    }
    
}