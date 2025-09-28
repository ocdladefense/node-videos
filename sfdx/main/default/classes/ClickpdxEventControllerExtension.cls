public without sharing class ClickpdxEventControllerExtension extends CommunityController {
    
    
    
    
    public Event__c evt {get;private set;}
    
    public Id evtId {get;private set;}
    
    public Boolean isActive {get;private set;}
    
    public Boolean isRegistrationEnabled {get;private set;}
    
    public String profileName {get;private set;}

    public List<Chapter__c> chapters {get; private set;}
    
    

    
    



    

     
    
    public ClickpdxEventControllerExtension() {
        Map<String,String> params = ApexPages.currentPage().getParameters();
        
        this.evtId = (Id)params.get('id');
    }
    
    
    public PageReference loadEvent() {
        this.evt = Database.query('SELECT Id, Name, Is_Active__c, Include_In_Catalog__c, DisabledRegistrationInstructions__c, RegistrationInstructions__c, Registration_Enabled__c, Overview__c, Venue__c, Agenda__c, Start_Date__c, End_Date__c, Banner_Date_Text__c, Banner_Location_Text__c, Early_Bird_End_Date__c, Image_Thumbnail_Url__c FROM Event__c WHERE Id = :evtId');

        this.isRegistrationEnabled = this.evt.Registration_Enabled__c;

        this.isActive = this.evt.Is_Active__c;
        
        this.chapters = [SELECT Id, Name, StartDate__c, Title__c, PublishVideo__c, VideoURL__c FROM Chapter__c WHERE Event__c = :this.evtId ORDER BY Number__c];

        return null;
    }
    
    
    public String getOverview() {
        
        return null != this.evt.Overview__c ? this.evt.Overview__c : this.getComponent('Overview');
    }
    
    
    
    public String getAgenda() {
        
        return null != this.evt.Agenda__c ? this.evt.Agenda__c : this.getComponent('Agenda');
    }
    
    public String getSecondaryAgenda() {
        
        return this.getComponent('Investigation Track');
    }  
    
    
    public String getVenue() {
        
        return null != this.evt.Venue__c ? this.evt.Venue__c : this.getComponent('Venue');
    }
    
    
    public String getEventCssClass() {
        String tmp = this.evt.Name.replace(' ', '-');
        return tmp.toLowerCase();
    }
    
    
    
    public String getComponent(String cName) {
        String value;

        
        try {
            value = [SELECT Body__c FROM PageComponent__c WHERE Name = :cName AND Event__c = :this.evt.Id LIMIT 1].Body__c;
        } catch(System.QueryException e) {
            value = null;
            // throw e;
        }
        
        return value;
    }
    
    
    

    


}