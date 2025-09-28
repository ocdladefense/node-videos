public without sharing class EventRegistrationUpdate {

    public Event__c theEvent {get;private set;}
    
    public OrderItem theLine {get; private set;}
    
    public String lineData {get{
        if(null == theLine.Data__c || theLine.Data__c == null){
            return '{}';
        } else return theLine.Data__c;
            }private set;}
    
    public String lineId {get{return theLine.Id;}private set;}
    
    public EventRegistrationUpdate(){
        Map<String,String> params = ApexPages.currentPage().getParameters();
        
		this.loadEvent(params.get('lineId'));
    }
    
    public EventRegistrationUpdate(Id lineId){
        this.loadEvent(lineId);
    }
    
    private void loadEvent(Id lineId){
        theLine = [SELECT Id, FirstName__c, LastName__c, Product2.Name, Product2.Event__c, Data__c FROM OrderItem WHERE Id = :lineId];
        theEvent = [SELECT Id, Name FROM Event__c WHERE Id = :theLine.Product2.Event__c];        
    }
    
    @TestVisible
    private static Boolean isEmptyJson(String theJson){
        if(null == theJson) return True;
        
        if('' == theJson || theJson.trim() == ''){
            return True;
        }
        
        return False;
    }
    
    private static String getValue(Map<String,String> data, String key){
        return hasKey(data,key) ? data.get(key) : '';
    }
    
    @RemoteAction
    public static Boolean sendEmail(Id lineId){
        List<Id> lineIds = new List<Id>{lineId};
            
            ClickpdxStoreProductConfirmation.sendProductEmails(lineIds,'AC19 Update');
        return True;
    } 
    
    private static Boolean hasKey(Map<String,String> data,String key){
        String meal;
        if(null == data) return False;
    
    	meal = data.get(key);
    
    	if(null == meal) return False;
    	if('' == meal || meal.trim() == '') return False;
    	return True;
    }
    /**
     * @name updateEventRegistration
     * 
     * @description, Update the <Data__c> field for an individual OrderItem with a JSON string.
     */
    @RemoteAction
    public static Boolean doUpdate(String theJson, Id lineId){
		// Decode the json
        String meal;
        String breakout;
        String newJson;
        Map<String,String> newData = new Map<String,String>();
            
		if( null == theJson ) return False;
        
        OrderItem existingLine = null == lineId ? new OrderItem(Data__c='{}') : [SELECT Id, Data__c FROM OrderItem WHERE Id = :lineId];
        
        Map<String,String> existingData = isEmptyJson(existingLine.Data__c) ? new Map<String,String>() : (Map<String,String>)JSON.deserialize(existingLine.Data__c,Map<String,String>.class);
        
        Map<String,String> passedData = (Map<String,String>)JSON.deserialize(theJson,Map<String,String>.class);
        
        
        meal = hasKey(passedData,'meal') ? passedData.get('meal') : getValue(existingData,'meal');
        breakout = hasKey(passedData,'breakout') ? passedData.get('breakout') : getValue(existingData,'breakout');
        newData.put('meal',meal);
        newData.put('breakout',breakout);
        
        if(null != lineId){
            OrderItem line = new OrderItem(Id=lineId, Data__c = JSON.serialize(newData));
            
            update line;
        }
        
        return True;
    }
    
}