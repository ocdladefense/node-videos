global class Registration {
 
    public static Id MORROW_EVENT_ID {get{return null == MORROW_EVENT_ID ? 'a23VJ0000048ayT' : MORROW_EVENT_ID;}public set;}

    
    private static String[] fields = new String[]{
        'Id','Quantity','OrderId','Contact__r.Name','Contact__r.FirstName','Contact__r.LastName','Product2.AllowedRegistrations__c',
        'FirstName__c','LastName__c','Order.OrderNumber','Data__c'
    };

        
        
    webservice static List<Id> getWhoIds(List<Id> recordIds){
		List<Id> whoIds = new List<Id>();
        for(Registration__c r :[SELECT Id, Contact__c FROM Registration__c WHERE IsPrimary__c = True AND Id = :recordIds]){
            whoIds.add(r.Contact__c);
        }
        
        return whoIds;
    }

    
    
    webservice static List<Id> getWhatIds(List<Id> recordIds){
		List<Id> whatIds = new List<Id>();
        for(Registration__c r :[SELECT Id, OrderProduct__r.Product2.Event__c FROM Registration__c WHERE IsPrimary__c = True AND Id = :recordIds AND OrderProduct__r.Product2.Event__c != NULL]){
            whatIds.add(r.Contact__c);
        }
        
        return whatIds;
    }

    webservice static List<SObject> createRegistrations(Id orderId, Id eventId){
        return createRegistrations(new List<Id>{orderId},eventId);
    }
    
    webservice static Boolean hasRegistrations(Id orderId){
        return hasRegistrations(new List<Id>{orderId});
    }
    
    
    webservice static List<Id> addSeats(List<Id> recordIds) {
        List<Registration__c> sources = [SELECT Id, Name, Order__c, OrderProduct__c, Note1Override__c, Note2Override__c, Note4__c
                                         FROM Registration__c WHERE Id = :recordIds];
        List<Registration__c> targets = new List<Registration__c>();
        
        for(Registration__c reg :sources) {
        	Registration__c target = reg.clone();
            target.Name = reg.Name;
            target.Note4__c = 'added seat';
            targets.add(target);
        }
        
        insert targets;
        
        return new List<Id>(new Map<Id, Registration__c>(targets).keySet());
    }
    
 
    
    
    /**
- Manually send out Ken Morrow dinner selection emails.

- Last updated: 2024-11-15

- Ken Morrow tickets often go on sale before the menu is decided.  Links to the EventManager/meal selection for Ken Morrow are contained in the Product Confirmation emails for the Ken Morrow tickets.  Product confirms aren't activated until the menu is decided.  This script will send out Product Confirm emails to customers who purchased tickets before the menu was decided.
**/
    webservice static void sendProductConfirmEmail(List<Id> recordIds) {

        List<Registration__c> registrations = [SELECT Id, OrderProduct__c FROM Registration__c WHERE Id = :recordIds];
        
        List<Id> orderProductIds = new List<Id>();
        Set<Id> uniques;
        
        
        for(Registration__c reg : registrations) {
            Id orderProductId = reg.OrderProduct__c;
            orderProductIds.add(orderProductId);
        }
        
        uniques = new Set<Id>(orderProductIds);
        
        System.debug(uniques.size());
        
        MailApiConfig config = new MailApiConfig();
        config.sample = False;
        config.generator = 'ProductConfirmationEmail';
        
        OcdlaMail.sendEmails(new List<Id>(uniques), config);
    }
    

    
    
    public static Boolean hasRegistrations(List<Id> orderIds){
        if(null == orderIds) throw new RuntimeException('OrderId cannot be null.');
		List<Registration__c> regs = [SELECT Id FROM Registration__c WHERE Order__c = :orderIds];
        
        return (null == regs || regs.size() == 0) ? false : true;
    }
    
    
    
    public static List<SObject> createRegistrations(Map<Id,Order> theOrders, Id eventId){
        return createRegistrations(new List<Id>(theOrders.keySet()),eventId);
    }
    
    
    public static List<SObject> createRegistrations(Map<Id,Order> theOrders) {
        return createRegistrations(new List<Id>(theOrders.keySet()), Registration.MORROW_EVENT_ID);
    }
    
    
    public static List<SObject> createRegistrations(List<Id> theOrders, Id eventId){
        String query = String.join(fields,',');
        
        List<OrderItem> lines = Database.query('SELECT '+query+' FROM OrderItem WHERE OrderId = :theOrders AND Product2.Event__c = :eventId');
        
        
        List<Registration__c> regs = new List<Registration__c>();
        
        for(OrderItem line : lines){
            Integer allowed = (Integer)(line.Product2.AllowedRegistrations__c == null ? 1 : line.Product2.AllowedRegistrations__c);
            Integer numRegistrants = (Integer)(allowed * line.Quantity);
            JsonData data = new JsonData(line.Data__c);
        
            for(Integer x = 0; x < numRegistrants; x++){
                Map<String,String> d = data.get(x);
                Registration__c reg = createRegistration(line,d,True);
                regs.add(reg); 
            }
        }
        
        // Remove existing Registrations?
        
        insert regs;
        
        return regs;
    }
    
    
    

    @testVisible
    private static Boolean isEmpty(String firstName){
		return null == firstName || ''== firstName.trim();
    }
    

    
    public static Boolean hasEventTickets(Id orderId, Id eventId){
        return hasEventTickets(new List<Id>{orderId}, eventId);
    }
    
    public static Boolean hasEventTickets(List<Id> orderIds, Id eventId){
        List<OrderItem> lines = [SELECT Id FROM OrderItem WHERE OrderId = :orderIds AND Product2.Event__c = :eventId];
        
        return !(null == lines || lines.size() == 0);   
    }
    
    public static Boolean hasEventTickets(List<Id> orderIds) {
		return hasEventTickets(orderIds, Registration.MORROW_EVENT_ID);
    }
    
    
    public static Registration__c createRegistration(OrderItem line, Map<String,String> data, Boolean isPrimary){
        
        Registration__c reg = new Registration__c();
        reg.Name = line.Contact__r.Name;
        reg.FirstName__c = line.FirstName__c == null ? line.Contact__r.FirstName : line.FirstName__c;
        reg.LastName__c = line.LastName__c == null ? line.Contact__r.LastName : line.LastName__c;
        reg.OrderProduct__c = line.Id;
        reg.Order__c = line.OrderId;
        reg.IsPrimary__c = isPrimary;
        
        return reg;
    }
 
    
    
    public class RuntimeException extends Exception{}
    
}