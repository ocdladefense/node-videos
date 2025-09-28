public class StoreHome extends CommunityController {

    public List<PageComponent__c> promoted {get;private set;}


    
    public StoreHome(){
        promoted = new List<PageComponent__c>();
        
        template = Page.OcdlaPageTemplateStore;
        
        promoted.addAll([SELECT Id, Name, Body__c FROM PageComponent__c WHERE IsPromoted__c = True ORDER BY Order__c]);
    }
    
    
}