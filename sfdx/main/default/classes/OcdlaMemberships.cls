public class OcdlaMemberships {

    public List<OrderItem> lines {get; set;}
    
    public Event__c e {get; private set;}
    
    Map<String,String> p = new Map<String,String>();
    
    public String retUrl {get;private set;}
    
    public List<SelectOption> lists {get;private set;}
    
    public String selectedListId {get;set;}
    
     
    public OcdlaMemberships(){
        p = ApexPages.currentPage().getParameters();
        Id listId = p.get('listId');
        
        retUrl = null != listId ? '/apex/OcdlaMemberships?listId='+listId : '/apex/ClickpdxOrderItems';
        

        lines = [SELECT Id, OrderId, Order.OrderNumber, ConfirmationSentDate__c, Description, UnitPrice, Quantity, FirstName__c, LastName__c, Contact__c, Contact__r.FirstName, Contact__r.LastName,
                 Note_1__c, Note_2__c, Note_3__c, TotalPrice, Product2Id, Product2.Name FROM OrderItem WHERE Product2.Family = 'Memberships' ORDER BY CreatedDate DESC];


    }
    
	
    public List<SelectOption> getLists(){
        List<Event__c> events = [SELECT Id, Name FROM Event__c ORDER BY Start_Date__c DESC];
        List<SelectOption> eventOptions = new List<SelectOption>();
        
        for(Event__c e : events){
            eventOptions.add(new SelectOption(e.Id,e.Name));
        }
        
        return eventOptions;
       
    }
    
    
}