global without sharing virtual class ClickpdxOpportunity {

    @TestVisible
    protected Opportunity cart;
    
    public String cartId {get;private set;}
    
    protected Map<String,ClickpdxCartItem> cartItems = new Map<String,ClickpdxCartItem>();
    
    protected Account a; 

    public Opportunity getOpportunity(){
        return this.cart;
    }
    // END MEMBERS
    // //
    //    // // // // 
    
    public ClickpdxOpportunity(){
        this([SELECT Id, Name FROM Account WHERE Id = :OrgOcdla.getGuestCheckoutAccountId()]);
    }
    
    public List<OpportunityLineItem> getLineItems(){
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        
        
        for(ClickpdxCartItem line :this.cartItems.values()){
            lines.add(line.getSObject());
        }
        
        return lines;
    }
    
    public ClickpdxOpportunity saveAll(){
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        
        for(ClickpdxCartItem li : this.cartItems.values()){
            OpportunityLineItem l = li.getSObject();
            li.opportunityId = this.cartId;
            lines.add(l);
        }
        
        upsert lines;
        
        return this;
    }
    
    public ClickpdxOpportunity(Account acc){
        this.a = acc;
        this.cart = this.getOpportunitySObject(this.a); 
        this.cartItems = new Map<String,ClickpdxCartItem>();
    }
    
    public ClickpdxOpportunity(Account acc, String opportunityName){
        this.a = acc;
        this.cart = this.getOpportunitySObject(this.a); 
        this.cartItems = new Map<String,ClickpdxCartItem>();
    }    
    
    
    public ClickpdxOpportunity(String opportunityId){
		Id accountId;
        
        this.cart = this.getOpportunitySObject(opportunityId);
        accountId = (null == this.cart.AccountId ? OrgOcdla.getGuestCheckoutAccountId() : this.cart.AccountId);
		this.a = [SELECT Id FROM Account WHERE Id = :accountId];
        this.cartItems = ClickpdxCartItem.loadFromOpportunityId(this.cart.Id);
    }
    
    
    public static ClickpdxOpportunity loadFromOpportunityId(String opportunityId){
        ClickpdxOpportunity theOpp;
        
        theOpp = new ClickpdxOpportunity(opportunityId);
        
        return theOpp;
    }
    
    public Id getCartId(){
        return null != this.cart.Id ? this.cart.Id : null;
    }
    
    public Map<String,ClickpdxCartItem> getItems(){
        return this.cartItems;
    }
    
    protected virtual Opportunity getOpportunitySObject(Account a){
    	return this.getOpportunitySObject(a,null);
    }
    
    private Opportunity getOpportunitySObject(Account a, String opportunityName){
		Opportunity opp = new Opportunity();
    	opp.CloseDate = date.today().addMonths(1);
    	opp.Name = (null == opportunityName ? 'System Created Opportunity' : opportunityName);
    	opp.StageName = 'Prospecting';
    	opp.AccountId = a.Id;
    	opp.Pricebook2Id = OrgOcdla.getStdPricebookId();
        return opp;
    }
    
    

    
    
    public virtual Opportunity getOpportunitySObject(){
        return getOpportunitySObject(this.a, null);
    }
    


    
    protected Opportunity getOpportunitySObject(Id oppId){
        List<Opportunity> opp = new List<Opportunity>();
        
        if(null == oppId){
            throw new ClickpdxOpportunityException('Cannot retrieve Shopping Cart Opportunity when Id is NULL.');
        }
        
        opp.addAll([SELECT Id, Name, AccountId, StageName FROM Opportunity WHERE Id = :oppId]);
        
        if(opp.size() < 1){
            throw new ClickpdxOpportunityException('Error when retrieving Opportunity: Shopping Cart Opportunity with Id, '+oppId+', cannot be found or is invalid.');
        } else if (opp[0].StageName == 'Closed Won') {
			throw new ClickpdxOpportunityException('Opportunity has already been Closed.');
        }
        
        return opp[0];
    }

    
/*
    @RemoteAction
    webservice static Order convertToOrderStub(Id oppId){
        return new Order();
    }
    
    @RemoteAction
    webservice static String convertToOrder(Id oppId){
    	return '';
    }
    
    @future
    public static void convertToOrderFuture(Id oppId){
 		       
    }
*/
 
    public class ClickpdxOpportunityException extends Exception{}
    
}