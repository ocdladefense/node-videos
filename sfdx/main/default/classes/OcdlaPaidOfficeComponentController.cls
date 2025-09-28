public class OcdlaPaidOfficeComponentController {

    public Id oppId {get;set;}  
    
    private Event__c theEvent {get;private set;}
    
    public List<ClickpdxCartItem> registrants;
    
    public Boolean hasRegistrants {get;private set;}
    
    public List<Opportunity> registrationLists;
    
    public Id currentCartOpportunityId {get;private set;}
    
    public List<SelectOption> getRegistrationListOptions;
    
    public Boolean hasErrors {get;private set;}
    
    public String errorMessage {get;set;}
    
    public Boolean isCurrentShoppingCart {get; private set;}
    
    public Boolean testMode {get; private set;}
    
    private Map<String,String> params;
    
    public Map<String,Id> selectedPricebookEntries{get; set;}
    

    
    public List<ClickpdxCartItem> getRegistrants(){
		return this.registrants;
    }
    
    public Map<String,Id> getSelectedPricebookEntries(){
        return this.selectedPriceBookEntries;
    }
    
    public OcdlaPaidOfficeComponentController(){
        this.selectedPricebookEntries = new Map<String,Id>();
        this.params = ApexPages.currentPage().getParameters();
        this.oppId = this.params.get('id');

        this.currentCartOpportunityId = this.oppId;
        this.registrants = ClickpdxCartItem.loadOpportunityLineItemsFromOpportunityId(this.currentCartOpportunityId);

        for(ClickpdxCartItem li :this.registrants){
            this.selectedPricebookEntries.put(li.opportunityLineItemId,li.pricebookEntryId);
        }
        
        this.hasRegistrants = True;
        this.isCurrentShoppingCart = True;
		
        this.testMode = null != this.params.get('test') ? True : False;
    }

    
    public String getEventName(){
		return [SELECT Name FROM Opportunity WHERE Id = :this.oppId LIMIT 1].Name;
    }

    
    public Boolean getHasRegistrants(){
        return (this.registrants == null || this.registrants.size()<1 ? False : True);
    }

    public Map<String,ClickpdxCartItem> getRegistrantsFromOpportunity(Id opportunityId){
        return ClickpdxCartItem.loadFromOpportunityId(opportunityId);
    }
    
    public List<SelectOption> getAvailableTickets(){
    	List<SelectOption> tickets = new List<SelectOption>();
        
        for(PriceBookEntry p :this.getEventProducts()){
           Decimal unitPrice = p.UnitPrice;
           ClickpdxPriceRule discount;
			String displayName;
			String priceBookDisplayName;
            
           discount = null == p.Discounts__c ? null : (ClickpdxPriceRule)JSON.deserialize(p.Discounts__c, ClickpdxPriceRule.class);
 
            priceBookDisplayName = OrgOcdla.getPriceBookDisplayName(p.Pricebook2Id);
            
            if(null != discount && this.theEvent.Early_Bird_End_Date__c >= System.today()){
          		displayName = p.Product2.Name + ' - $' + String.valueOf(discount.price) + ' ('+ discount.name + ')';
               }
            else {
          		displayName = p.Product2.Name + ' - $' + p.UnitPrice;              
            }
           
           tickets.add(new SelectOption(p.Id, displayName, !p.IsActive));
        }
        
        return tickets;
    }
    
    
    
    public String getAvailableTicketsJson(){
        
        List<SelectOption> options;
        
        
        JsonTicket[] tickets = new JsonTicket[]{};

        options = this.getAvailableTickets();
        
        
        for(SelectOption o :options){
            // if(o.getDisabled()) continue;
            JsonTicket t = new JsonTicket();                
            try {
                t.label = o.getLabel();
                t.value = o.getValue();
                t.disabled = o.getDisabled();
                tickets.add(t);
            } catch(Exception e){
                t.label = e.getMessage()+e.getStackTraceString();
                t.value = '';
                t.disabled = true;
            }
        }
        
        
        return JSON.serialize(tickets);
    }
    
    public class JsonTicket {
        
        public String value;
       
        public String label;
        
        public Boolean disabled;
        
        public JsonTicket(){}
    }
    
    
    
    
    public List<SelectOption> getRegistrationListOptions(){
        List<Opportunity> opportunities;
        List<SelectOption> options = new List<SelectOption>();
        
        List<SelectOption> savedCarts = new List<SelectOption>();
        List<SelectOption> currentCarts = new List<SelectOption>();
        
        savedCarts.add(new SelectOption('','Your previously saved events...',True));
        currentCarts.add(new SelectOption('','Current shopping cart...',True));
        
        opportunities = [SELECT Id, Name, LastModifiedDate FROM Opportunity LIMIT 40];
        
        
        if(null == this.currentCartOpportunityId){
            String opportunityIdAsString = null == this.currentCartOpportunityId ? '' : (String)this.currentCartOpportunityId;
            currentCarts.add(new SelectOption(opportunityIdAsString, 'My Current Shopping Cart'));
        }
        
        for(Opportunity o :opportunities){
            String label = ('  '+o.Name + ' ('+formatDate(o.LastModifiedDate)+')');
            if(o.Id == this.currentCartOpportunityId){
                String opportunityIdAsString = null == this.currentCartOpportunityId ? '' : (String)this.currentCartOpportunityId;
               currentCarts.add(new SelectOption(opportunityIdAsString, 'My Current Shopping Cart'));
            }
        	else savedCarts.add(new SelectOption((String)o.Id, label));
        }
        
        options.addAll(currentCarts);
        options.add(new SelectOption('','',True));
        options.addAll(savedCarts);
        
        return options;
    }
    
    
    
    public static String formatDate(DateTime d) {
        return d.month() + '/' + d.day() + '/' + d.year();
    }
    
    
    private List<PriceBookEntry> getEventProducts(){
        List<PriceBookEntry> entries = new List<PriceBookEntry>();
        List<PriceBookEntry> db = null;
        
        // Boolean earlyBirdOn = null != evt[0].Early_Bird_End_Date__c && System.today() <= evt[0].Early_Bird_End_Date__c;
        
		// Show only active products, but query for both active AND inactive price book entries.
		//  Inactive pricebook entries should be rendered as disabled, for example.
        db = [SELECT Id, IsActive, PriceBook2Id, PriceBook2.Name, ProductCode, UnitPrice, Discounts__c, Product2.Name FROM PriceBookEntry WHERE Product2Id IN 
              (SELECT Id FROM Product2 WHERE Family = 'Memberships' AND IsActive=True)];
        
        
         
        if(null != db && db.size()>0){
            entries.addAll(db);
        }
        
        return entries;
    }
    

    
    
    
    public List<SelectOption> availableAddOns(){
        return null;
    }
    

    
    
    private Boolean isEmptySelection(String data){
        if(null == data){
            return True;
        }
    	return '' == data.trim();
    }

    

    
}