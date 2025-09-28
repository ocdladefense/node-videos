public class EventManagerController {

    public Contact me {public get; private set;}
    
    public String profileName {get;private set;}
    
    public PageReference pageTemplate {get;private set;}
      
    // Registered Events: re
    public List<Event__c> re {get;private set;}
    
    private Id eventId {get;private set;}
    
    public String pageDescription {get; private set;}
    
    private Id contactId {get;private set;}
    
    private Id lineId;
    
    public List<Registration__c> registrations {public get;private set;}
    
    public static Map<Id, Meal__c> tmpMeals {get; private set;}
        
    public static List<Meal__c> meals {get; private set;}
    
    public static Map<String,List<MenuItem__c>> menuItems {get; private set;}
    
    public static Map<Id,Map<String,String>> mealOptions {public get; private set;}

    
    public String userProfileName {public get {
    	return [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name.toLowerCase().replace(' ','-');
    } private set;}
    
    
    
    /**
     * Fetch the list of Registrations that this customer can manage.
     * 
     * @constructor - EventManagerController()
     */
    public EventManagerController(){
        Map<String,String> params = new Map<String,String>();
		params.putAll(ApexPages.currentPage().getParameters());
        
		this.eventId = params.get('id'); 
		// this.eventId = null == this.eventId ? Registration.MORROW_EVENT_ID : this.eventId;
        
        
        Event__c theEvent = [SELECT Id, Name FROM Event__c WHERE Id = :this.eventId];

		menuItems = new Map<String,List<MenuItem__c>>();
        tmpMeals = new Map<Id, Meal__c>([SELECT Id, Name, StartTime__c FROM Meal__c WHERE Event__c = :this.eventId ORDER BY StartTime__c ASC]);
		meals = tmpMeals.values();
        

        
        for(Id mealId : tmpMeals.keySet()) {
            menuItems.put(mealId,[SELECT Id, Name, ShortName__c, Description__c FROM MenuItem__c WHERE Meal__c = :mealId ORDER BY DisplayOrder__c ASC NULLS LAST]);
        }

   		mealOptions = new Map<Id,Map<String,String>>();
        //String>{'beef'=>'Beef','chicken'=>'Chicken','vegan'=>'Vegan'};
		
        for(Id mealId : menuItems.keySet()) {
			Map<String,String> opts = new Map<String,String>();
            for(MenuItem__c menuItem : menuItems.get(mealId)) {
                opts.put(menuItem.ShortName__c,menuItem.Name);
            }
            
            mealOptions.put(mealId,opts);
        }
        
        
		String pageComponentName = theEvent.Name;
        
        List<PageComponent__c> pageElements = [SELECT Body__c FROM PageComponent__c WHERE Event__c = :this.eventId AND Name = 'EventManager' LIMIT 1];
        
		// For now let's only use the first; however we should plan.
        this.pageDescription = (null == pageElements || pageElements.size() < 1) ? 'Event description' : pageElements[0].Body__c;
        
        // Identify the currently logged-in user.
		Id userId = UserInfo.getUserId();
        
        // Identify Registrations for the specified Contact and Event.
        contactId = params.get('contactId');

        
        
        
        // Override Contact with that related to the current user?
        // contactId = [SELECT ContactId FROM User WHERE Id = :userId].ContactId;
        
        if(null != contactId && null != eventId) {
            me = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
            
            // Using Contactid and Registration.MORROW_EVENT_ID
            this.registrations = this.loadRegistrations(contactId, eventId);
            
            List<OrderItem> tickets = [SELECT Id, Product2.Id, Product2.Event__c FROM OrderItem
                                       WHERE Product2.Event__c != null AND Order.BillToContactId = :contactId];
            List<Id> eventIds = new List<Id>();
            
            for(OrderItem line :tickets){
                eventIds.add(line.Product2.Event__c);
            }  
            
            re = getAvailableEvents(contactId, True);
            
            this.pageTemplate = Page.OcdlaPageTemplateStore;
            
            EventItem foobar = new EventItem();
        }
    }
    
    
    
    private class EventManagerConfig {
        
        public Date RegistrationEndDate;
        
        public String RegistrationEndDateMessage;
        
        public List<String> Features;
        
        public String WelcomeText;
        
        public EventManagerConfig(){
            
        }
    }
    
    
    
    @RemoteAction
    public static OrderItemUpdateStatus[] saveOrderLineData(Registration__c reg){
        OrderItemUpdateStatus[] statuses = new OrderItemUpdateStatus[]{};
            
        // Registration__c reg = JSON.deserialize(data, Registration__c.class);
        
        update reg;
        
        return statuses; 
    }
    
    
    
    @TestVisible
    private class OrderItemUpdateStatus {
        public Id id;
        
        public String status;
        
        public OrderItem theItem;
        
        public Boolean isSuccess = True;
        
        public OrderItemUpdateStatus(Id OrderItemId){
            this.id = OrderItemId;
        }
    }
    
    
    
    public List<Registration__c> loadRegistrations(Id contactId, Id eventId){
		return [SELECT Id, Order__c, OrderProduct__c, FirstName__c, LastName__c, Meal__c, Meal2__c, MealNotes__c, Meal2Notes__c FROM Registration__c
                WHERE Contact__c = :contactId AND OrderProduct__r.Product2.Event__c = :eventId];
    }
    
    
    private List<Event__c> getAvailableEvents(Id contactId, Boolean SHOW_ALL){
        
        if(False && SHOW_ALL){
            return [SELECT Id, Name, End_Date__c, Start_Date__c, Banner_Date_Text__c, Banner_Location_Text__c FROM Event__c];
        }
        // this.evtId = (Id)params.get('id');
		List<OrderItem> tickets = [SELECT Id, Order.EffectiveDate, Product2.Id, Product2.Event__c
                                   FROM OrderItem WHERE Product2.Event__c != null AND (Order.BillToContactId = :contactId OR Contact__c = :contactId)];
        List<Id> eventIds = new List<Id>();
        
        for(OrderItem line :tickets){
            eventIds.add(line.Product2.Event__c);
        } 
        
        return [SELECT Id, Name, End_Date__c, Start_Date__c, EventManagerEnabled__c,EventManagerConfig__c,
                Banner_Date_Text__c, Banner_Location_Text__c FROM Event__c WHERE Id = :eventIds];
    }
    
    
    
    /*
    public String getMorrowRegistrationData(){
        List<OrderItem> registrations = new List<OrderItem>();
        
        registrations.addAll([SELECT Id, OrderItemNumber, Order.OrderNumber, Product2.Name, Product2.Event__c, Product2.ClickpdxCatalog__DisplayName__c, Product2Id, Quantity, OrderId, FirstName__c, LastName__c, Contact__c, Data__c
                         FROM OrderItem WHERE (Order.BillToContactId = :this.contactId OR Contact__c = :this.contactId) AND PricebookEntry.Product2.Event__c = :eventId ORDER BY Order.OrderNumber DESC, Quantity ASC] );
        
        Map<String,List<Registration>> morrows = new Map<String,List<Registration>>();
        
        if(registrations.size() < 1){
            morrows.put('some-ocdla-id',new List<Registration>{createRegObject(new OrderItem())});
        }
        
        for(OrderItem line :registrations){
            Id theEventId = line.Product2.Event__c;
            if(null == morrows.get(theEventId)){
                morrows.put(theEventId,new List<Registration>{});
            }
            
            morrows.get(theEventId).add(createRegObject(line));
        }
        
        return JSON.serializePretty(morrows);
    }
    */

    /*
    private Registration createRegObject(OrderItem line){
            Registration m = new Registration();
            m.Id = line.Id;
            m.OrderId = line.OrderId;
        	m.Product2Id = line.Product2Id;
        	m.Product2Name = line.Product2.ClickpdxCatalog__DisplayName__c;
            m.FirstName = line.FirstName__c;
            m.LastName = line.LastName__c;
            m.Contact = line.Contact__c;
            m.Quantity = line.Quantity;
            m.Data = line.Data__c; 
            m.OrderNumber = line.Order.OrderNumber;
            
        	return m;
    }
    */
    
    /*
    private class Registration {
        
        public String FirstName;
        
        public String LastName;
        
        public Id Contact;
        
        public Id OrderId;
        
        public Id Product2Id;
        
        public String Product2Name;
        
        public String OrderNumber;
        
        public Id Id;
        
        public Decimal Quantity;
        
        public String Data;
        
        
    }
*/
    
    private class EventItem {
        public Event__c evt {get;private set;}
        
        public Id evtId {get;private set;}
        
        public Boolean isActive {get;private set;}
        
        public Boolean isRegistrationEnabled {get;private set;}
        
        public EventItem(){
            evt = null;
            evtId = null;
            isActive = True;
            isRegistrationEnabled = True;
        }
    }
 
    
    
    
    public class InvalidParameterException extends Exception {}
}