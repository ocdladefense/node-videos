public class OcdlaEvent {

    Event__c theEvent;
    
    List<Product2> tickets;
    
    Map<Id,PricebookEntry> entries;
    
    Map<String,Product2> eligibilities;
    
    public OcdlaEvent(Id eventId){
        entries = new Map<Id,PricebookEntry>();
        eligibilities = new Map<String,Product2>();
        
		theEvent = [SELECT Id, Name FROM Event__c WHERE Id = :eventId LIMIT 1];
        tickets = [SELECT Id, Name, OcdlaEligibleMemberStatuses__c, ClickpdxCatalog__StandardPrice__c, ClickpdxCatalog__MemberPrice__c,
                    ClickpdxCatalog__LineDescription__c FROM Product2 WHERE Event__c = :eventId];
        
        List<PricebookEntry> tmpEntries = [SELECT Id, UnitPrice, Product2Id FROM PricebookEntry WHERE Product2Id = :tickets];
        

        for(PricebookEntry entry :tmpEntries){
            Decimal salePrice;
            
            salePrice = ClickpdxPricebookEntryManager.getPrice(entry.Id);
            entry.UnitPrice = salePrice;
            
            entries.put(entry.Product2Id,entry);
        }
        
        for(Product2 prod :tickets){
            if(prod.OcdlaEligibleMemberStatuses__c == null) continue;
            String[] statuses = prod.OcdlaEligibleMemberStatuses__c.split(',');
            for(String status :statuses){
                eligibilities.put(status,prod);
            }
        }
    }
    
    public OrderItem createOrderItem(Contact c){
        OrderItem item;
        String status = c.Ocdla_Member_Status__c == null ? 'R' : c.Ocdla_Member_Status__c;
        Product2 eligible = eligibilities.get(status);
        
        if(eligible == null) return null;
        
        item = new OrderItem();
        PricebookEntry entry = entries.get(eligible.Id);
        item.PricebookEntryId = entry.Id;
        item.Quantity = 1.0;
        item.UnitPrice = entries.get(eligible.Id).UnitPrice;
        item.Contact__c = c.Id;
        item.FirstName__c = c.FirstName;
        item.LastName__c = c.LastName;
        item.Description = eligible.ClickpdxCatalog__LineDescription__c;
        return item;
    }

    public static ClickpdxPriceRule createPriceRuleObject(Decimal price, Date ebDate){
        
        ClickpdxPriceRule discount;
        Integer monthInteger = ebDate.month();
        Integer dayInteger = ebDate.day();
        String monthName = ClickpdxPriceRule.getMonthText(monthInteger);
        String description = 'through '+monthName+' '+String.valueOf(dayInteger);
        
        discount = new ClickpdxPriceRule();
        discount.name = 'Early Bird';
        discount.description = description;
        discount.price = price;
        discount.active = True;
        
        return discount;
    }
    
}