public with sharing class EditEventController {

    
    public String agenda {public get; public set;}
    
    private Id eventId;
    
    
    public EditEventController() {
        Map<String,String> params = ApexPages.currentPage()?.getParameters();
        
        if(params.get('id') != null) {
        	this.eventId = params.get('id');
        }
        
        Event__c theEvent = [SELECT Id, Agenda__c FROM Event__c WHERE Id = :this.eventId];
        
        this.agenda = theEvent.Agenda__c;
    }
    

  
    
    
    public PageReference doSubmit() {
        
        Event__c theEvent = new Event__c(Id=this.eventId, Agenda__c = this.agenda);
        update theEvent;
        
        return null;
    }
    
    
    public PageReference doCancel() {
        
        String theUrl = '/'+String.valueOf(this.eventId);
        
        return new PageReference(theUrl);
    }
}