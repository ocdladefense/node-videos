public without sharing class OcdlaOfficeMembershipRenewalController {
    
    public Opportunity opp {get;private set;}
    
    public String OpportunityName {get{return this.opp.Name;}private set;}
    
    public String AccountName {get{return this.opp.Account.Name;}private set;}
    
    public Id renewalId {get;private set;}
    
    public Boolean isActive {get;private set;}
    
    public Boolean isRegistrationEnabled {get;private set;}
    
    public String profileName {get;private set;}
    
    public PageReference pageTemplate {get;private set;}
    
    public PageReference getPageTemplate(){
        return this.pageTemplate;
    }
    
    public Component.ClickpdxShoppingCart getDynamicShoppingCart(){
        Component.ClickpdxShoppingCart theCart;
        
        theCart = new Component.ClickpdxShoppingCart(forOpportunityIdParam=this.renewalId);

        if(false && null == theCart.forOpportunityIdParam) {
            throw new ClickpdxShoppingCartException('forOpportunityIdParam not set or null.');
        }        
        
        return theCart;
    }
    
    public PageReference loadOpportunity(){
        this.opp = [SELECT Id, Name, Account.Name FROM Opportunity WHERE Id = :this.renewalId];

        this.isRegistrationEnabled = True;

        this.isActive = True;
        
        return null;
    }
    
    
    public OcdlaOfficeMembershipRenewalController() {
        Map<String,String> params = ApexPages.currentPage().getParameters();
        
        this.renewalId = (Id)params.get('id');

        this.pageTemplate = Page.OcdlaPageTemplateStore;
    }
    
    

    


}