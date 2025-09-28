public without sharing class OcdlaObjectToJson
{

    private final EventApi__Event__c event;

    public String jsonString {get;set;}
    
    List<OrderApi__Item__c> options = new List<OrderApi__Item__c>();
    
    public OcdlaObjectToJson(ApexPages.StandardController stdController) {
        this.event = (EventApi__Event__c)stdController.getRecord();

        this.options = [SELECT Id, Name, Ocdla_Is_Option__c, OrderApi__Display_Name__c, OrderApi__Price__c FROM OrderApi__Item__c WHERE EventApi__Event__c = :this.event.Id];
        
        jsonString = JSON.serialize(this);
    }
    

}