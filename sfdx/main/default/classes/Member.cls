public class Member {
    
    public static List<OrderItem> getMemberships(Id contactId) { 
        
        // Member's memberships are represented through purchases.
        // WHERE Order.EffectiveDate >= 2023-04-01 AND.
        List<OrderItem> memberships = [SELECT Id, Order.EffectiveDate FROM OrderItem WHERE Contact__c = :contactId AND
                                       Product2.Family = 'Memberships' ORDER BY Order.EffectiveDate DESC];
        
        return memberships;
    }
      
    
    // Assuming the Contact has a membership for membershipYear.
    // Returns True if the member would be considered a new member for the specified year.
    // This typtically means the member would not have membership purchases prior to that year.
    public static Boolean isNewMember(Id contactId, Integer membershipYear) {
        
        Integer purchaseYear = membershipYear - 1;
        Date anyPreviousMembershipPurchases = Date.newInstance(purchaseYear,4,1);
        
        List<OrderItem> memberships = [SELECT Id, Order.EffectiveDate FROM OrderItem WHERE Contact__c = :contactId AND
                                       Product2.Family = 'Memberships' AND Order.EffectiveDate < :anyPreviousMembershipPurchases
                                       ORDER BY Order.EffectiveDate DESC];
        
        return null == memberships || memberships.size() < 1;
    }
    
    
    
    public static Boolean hasMembershipsPriorTo(Id contactId, Integer membershipYear) {
        
		Integer purchaseYear = membershipYear - 1; 
        
		// This is the date around which the membership would have been purchased for the
		// above specified membership year.
		Date purchaseDate = Date.newInstance(purchaseYear, 4, 1);
        
        // Member's memberships are represented through purchases.
        // WHERE Order.EffectiveDate >= 2023-04-01 AND.
        List<OrderItem> purchases = [SELECT Id, Contact__c, Order.EffectiveDate FROM OrderItem WHERE Contact__c = :contactId AND
                                       Product2.Family = 'Memberships' AND Product2.OcdlaMembershipStatusGrant__c  != 'A' AND 
                                     Order.EffectiveDate < :purchaseDate ORDER BY Order.EffectiveDate DESC];
        
        return null != purchases && purchases.size() > 0;
    }
    
    public static Map<Id,Boolean> hasMembershipsPriorTo(List<Id> contactIds, Integer membershipYear) {
        
        Map<Id,Boolean> results = new Map<Id,Boolean>();
        
		Integer purchaseYear = membershipYear - 1; 
        
		// This is the date around which the membership would have been purchased for the
		// above specified membership year.
		Date purchaseDate = Date.newInstance(purchaseYear, 4, 1);
        
        // Member's memberships are represented through purchases.
        // WHERE Order.EffectiveDate >= 2023-04-01 AND.
        List<OrderItem> purchases = [SELECT Id, Contact__c, Order.EffectiveDate FROM OrderItem WHERE Contact__c = :contactIds AND
                                       Product2.Family = 'Memberships' AND Product2.OcdlaMembershipStatusGrant__c  != 'A'
                                     AND Order.EffectiveDate < :purchaseDate
                                     ORDER BY Contact__c, Order.EffectiveDate DESC];
        
        for(OrderItem line :purchases) {
            results.put(line.Contact__c, True);
        }
        
        return results;
    }
    
}