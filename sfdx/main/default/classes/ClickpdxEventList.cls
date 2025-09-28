global without sharing class ClickpdxEventList extends CommunityController {

    
    
    
    public List<ClickpdxEvent> theEvents;
    
    public Map<Integer,List<ClickpdxEvent>> events {get; private set;}
    
    public List<Integer> years {get; private set;}
    
    public static List<Product_Relation__c> relatedProducts {get;private set;}
    
    public String profileName {get;private set;}
    
	public static String query = 'SELECT Id, Name, Is_Active__c, Start_Date__c, Include_In_Catalog__c, Banner_Date_Text__c, Banner_Location_Text__c FROM Event__c';

    public static String legacyQuery = 'SELECT Id, Name, EventApi__Is_Active__c, EventApi__Start_Date__c FROM EventApi__Event__c WHERE EventApi__Is_Active__c=True ORDER BY EventApi__Start_Date__c DESC';    

    
    
    public ClickpdxEventList() {
        years = new List<Integer>{2026,2025,2024,2023,2022};
		events = new Map<Integer,List<ClickpdxEvent>>();

        for(Integer year : years) {
            List<Event__c> results = Database.query(query +' WHERE Include_In_Catalog__c=True AND CALENDAR_YEAR(Start_Date__c) = :year ORDER BY Start_Date__c ASC'); 
            
                try {
            List<ClickpdxEvent> theEvents = ClickpdxEvent.newFromSObjects(results);  
            events.put(year,theEvents);
        } catch(System.SObjectException e) {
            throw e;
        }

        }

        



    }
    
    

    
    
    
    /*
    // Events grouped by Year
    public Map<EventListKey,List<ClickpdxEvent>> getTheEvents(){
        Map<EventListKey,List<ClickpdxEvent>> eventsByYear = new Map<EventListKey,List<ClickpdxEvent>>();
        Map<EventListKey,List<ClickpdxEvent>> tmp = new Map<EventListKey,List<ClickpdxEvent>>();
        
        for(ClickpdxEvent e: theEvents){
            Integer theYear;
            if(e.startDate == null) continue; // Skip seminars missing an appropriate Start Date.
            
            theYear = e.startDate.year();
            List<ClickpdxEvent> theList = eventsByYear.get(new EventListKey(e));
            
            if(null == theList){ // && null == eventsByYear.get(theYear)) {
                eventsByYear.put(new EventListKey(e),new List<ClickpdxEvent>{e});
            } else {
                theList.add(e);
            }
        }
        
        List<EventListKey> sorted = new List<EventListKey>(eventsByYear.keySet());
        sorted.sort();
        
        for(EventListKey e :sorted){
            tmp.put(e,eventsByYear.get(e));
        }
        
        return tmp;
    }
    
    

*/
    
    public static List<Product_Relation__c> getRelatedProducts(Set<Id> eventIds, Id eventId) {
        if(null == relatedProducts) {
        
            relatedProducts = [SELECT Id, EnablePairing__c, Event__c, Name, PriceOverride__c, IsActive__c, 
                               Product__r.ClickpdxCatalog__ParentProduct__c,
                Product__r.ClickpdxCatalog__DisplayOrder__c, Product__r.ClickpdxCatalog__IsParent__c,
                               Product__r.ClickpdxCatalog__StandardPrice__c, Product__r.ClickpdxCatalog__MemberPrice__c,
                               Product__r.ClickpdxCatalog__DisplayName__c
                               FROM Product_Relation__c 
                WHERE Event__c = :eventIds AND IsActive__c = True];
        }
        
        List<Product_Relation__c> related = new List<Product_Relation__c>();
        
        for(Product_Relation__c rel :relatedProducts){
            if(eventId == rel.Event__c) related.add(rel);
        }
        
        return related;
    }    

 

}