public class ClickpdxEvent {
    
    public Id theId {get;private set;}
    
    public String name {get;private set;}
    
    public Boolean isActive {get;private set;}
    
    public Boolean isPublic {get;private set;}
    
    public String dateText {get;private set;}
    
    public String locationText {get;private set;}
    
    public DateTime startDate {get;private set;}
    
    public Integer startYear {get;private set;}
    
    public List<Product_Relation__c> related {get;set;}        
    
    
    
    
    public ClickpdxEvent(){}
    

    
    public ClickpdxEvent(SObject e) {
        this.theId = e.Id;
        this.name = (String)e.get('Name');
        this.isActive = (Boolean)e.get('Is_Active__c');
        this.startDate = (DateTime)e.get('Start_Date__c');
        this.isPublic = (Boolean)e.get('Include_In_Catalog__c');
        this.dateText = (String)e.get('Banner_Date_Text__c');
        this.locationText = (String)e.get('Banner_Location_Text__c');
    }
    

    
    public Boolean getHasRelatedProducts() {
        return null != related && related.size() > 0;
    }
    
    
    public static List<ClickpdxEvent> newFromSObjects(List<Event__c> events) {
        Map<Id,Event__c> sobjectMap = new Map<Id,Event__c>(events);
        
        List<ClickpdxEvent> theEvents = new List<ClickpdxEvent>();
        
        
        for(Event__c e :events){
            ClickpdxEvent evt = new ClickpdxEvent(e);

	        List<Product_Relation__c> related = ClickpdxEventList.getRelatedProducts(sobjectMap.keySet(), e.Id);
            evt.related = related;
            theEvents.add(evt);
        }
        
        return theEvents;
    }

    

}