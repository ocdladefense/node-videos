public without sharing class ClickpdxCartItem {
    
    private static final String[] fields = new String[]{
        'Id','OpportunityId', 'PricebookEntryId','Product2Id','ParentLineId__c',
        'Name', 'FirstName__c', 'LastName__c', 'OcdlaStateLicense__c', 'Email__c', 'Contact__c','Data__c',
            'ProductCode','Product2.Name','Product2.Forms__c','Product2.ClickpdxCatalog__LineDescription__c',
            'UnitPrice','TotalPrice', 'Quantity','Description'};
    
    public String clientId {get;set;}
    
    public Id opportunityLineItemId {get;set;}    
    
    public Id opportunityId {get;set;}
    
    public Id parentLineId {get;set;}
      
    public String firstName {get;set;}  
    
    public String lastName {get;set;}
    
    public String email {get;set;}
    
    public String action {get;set;}
    
    public Id contactId {get;set;}
    
    public Id product2Id {get;set;}
    
    public String license {get;set;}
    
    public Id pricebookEntryId {get;set;}
    
    private PricebookEntry entry{get;set;}
    
    public String productCode {get;set;}
    
    public String description {get;set;}
    
    public Decimal quantity {get;set;}

    public Decimal unitPrice {get;set;}
    
    public Decimal totalPrice {get{
        if(null == this.unitPrice || null == this.quantity){
            return null;
        }
		else return (this.unitPrice * quantity).setScale(2);
    }set;}
    
    public String grants {get;set;}
    
    public String data {get;set;}
    

    //  public List<ClickpdxPriceRule> priceRules {get;private set;}
    
    //public ClickpdxCartItem clone(){
    //    return cloneCartItem(this);
    //}
    public String key(){
        if(null == this.opportunityLineItemId && null == this.clientId){
            throw new ClickpdxShoppingCartException('Invalid key exception: ERROR_BOTH_ID_AND_CLIENTID_EMPTY');
        }
        return null == this.opportunityLineItemId ? this.clientId : this.opportunityLineItemId;
    }
    
    // If the underlying SObject is deleted
    // then we remove the opportunityLineItemId but keep the original `key` value
    // so that this item can be later updated and saved to a new SObject.
    public ClickpdxCartItem del(){
        OpportunityLineItem li = new OpportunityLineItem(Id=this.opportunityLineItemId);
        delete li;
        
        this.opportunityLineItemId = null;
		return this;
    }
    
    public static List<OpportunityLineItem> deleteChildren(Id opportunityLineItemParentId){
        // Delete any existing cart items with the given parent Id
		List<OpportunityLineItem> forDelete;
        
        forDelete = [SELECT Id FROM OpportunityLineItem WHERE ParentLineId__c = :opportunityLineItemParentId];
        if(null != forDelete && forDelete.size() > 0){
            delete forDelete;
        }
        
        return forDelete;
    }
    
    public static Map<String,ClickpdxCartItem> loadFromOpportunityId(Id oppId){
        Map<String,ClickpdxCartItem> items = new Map<String,ClickpdxCartItem>();
        
        List<OpportunityLineItem> lis = Database.query('SELECT '+String.join(fields,',')+' FROM OpportunityLineItem WHERE OpportunityId = :oppId '+
                                        ' ORDER BY PricebookEntryId DESC, LastName__c ASC');
        
        for(OpportunityLineItem li :lis){
            ClickpdxCartItem line = new ClickpdxCartItem(li);
            items.put(line.key(), line);
        }
     
        return items;
    }
    

    
    public static List<ClickpdxCartItem> loadOpportunityLineItemsFromOpportunityId(Id oppId){
        List<ClickpdxCartItem> items = new List<ClickpdxCartItem>();
        
        List<OpportunityLineItem> lis = Database.query('SELECT '+String.join(fields,',')+' FROM OpportunityLineItem WHERE OpportunityId = :oppId '+
                                        ' ORDER BY ParentLineId__c, PricebookEntry.Product2.Name, Contact__r.LastName, Contact__r.FirstName');

        
        for(OpportunityLineItem li :lis){
            ClickpdxCartItem line = new ClickpdxCartItem(li);
            items.add(line);
        }
     
        return items;
    }
    
    
    public static Map<String,ClickpdxCartItem> loadFromOpportunityIdByEventTicket(Id oppId, Id eventId){
        Map<String,ClickpdxCartItem> items = new Map<String,ClickpdxCartItem>();
        
        
        List<OpportunityLineItem> lis = Database.query('SELECT '+String.join(fields,',')+' FROM OpportunityLineItem WHERE OpportunityId = :oppId AND'+
                                                       ' Product2.Event__c = :eventId');
        
        for(OpportunityLineItem li :lis){
            ClickpdxCartItem line = new ClickpdxCartItem(li);
            items.put(line.key(), line);
        }
        
        return items;
    }
    
    public ClickpdxCartItem(){
        clientId = getClientId();        
    }
    
    public ClickpdxCartItem(OpportunityLineItem li){
        clientId = getClientId();
        opportunityId = li.OpportunityId;
        pricebookEntryId = li.PricebookEntryId;
        opportunityLineItemId = li.Id;	
        parentLineId = li.ParentLineId__c;
        product2Id = li.Product2Id;
        productCode = li.ProductCode;
        unitPrice = li.UnitPrice;
        quantity = li.Quantity;
        firstName = li.FirstName__c;
        lastName = li.LastName__c;
        email = li.Email__c;
        contactId = li.Contact__c;
        description = li.Description;
        license = li.OcdlaStateLicense__c;
        data = li.Data__c;
    }
    
    // Set defaults
    
    public ClickpdxCartItem(PricebookEntry entry){
        clientId = getClientId();
        pricebookEntryId = entry.Id;
		unitPrice = getPrice(entry.Id);
        quantity = 1.0;
        firstName = null;
        lastName = null;
        email = null;
        contactId = null;
        description = getDescription(entry);
        license = null;
        data = null;
        entry = entry;
    }
    
    public ClickpdxCartItem(PricebookEntry entry, Map<String,Object> params){
        this.entry = entry;
        if(null == entry){
            throw new ClickpdxShoppingCartException('ClickpdxCartItem Error: cannot accept null PricebookEntry.');
        }
        params.put('pricebookEntryId',entry.Id);
        setDefaults(params);

        unitPrice = entry.UnitPrice;
    }
    
    
    public ClickpdxCartItem(Map<String,Object> params){
        String pricebookEntryId = (String)params.get('pricebookEntryId');
        ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(new List<Id>{pricebookEntryId});
        this.entry = manager.entry(pricebookEntryId);
		setDefaults(params);
    }
    
    public Boolean hasForms() {
        return this.entry.Product2.HasRequiredForms__c;
    }
    
    public Boolean hasFormsData(){
		return !(null == this.data || '' == this.data.trim());
    }
    
    
    private void setDefaults(Map<String,Object> params){
        Decimal theQuantity;
        String theDescription;
        if(params.get('quantity') instanceOf String){
            theQuantity = Decimal.valueOf((String)params.get('quantity'));
        } else if(params.get('quantity') instanceOf Decimal){
            theQuantity = (Decimal)params.get('quantity');
        }
        
        if(params.get('description') instanceOf String && '' != params.get('description')){
            theDescription = (String)params.get('description');
        } else {
            theDescription = getDescription(this.entry);
        }

        clientId = null == params.get('clientId') ? getClientId() : (String)params.get('clientId');
        
        opportunityId = null == params.get('opportunityId') ? null : (String)params.get('opportunityId');
        
        pricebookEntryId = null != params.get('pricebookEntryId') ? (Id)params.get('pricebookEntryId') : null;
        
        description = theDescription;
        
        opportunityLineItemId = (null != params.get('opportunityLineItemId') && ''!=(String)params.get('opportunityLineItemId')) ? (String)params.get('opportunityLineItemId') : null;
		
        if(null != params.get('price') && ''!=(String)params.get('price')){
            unitPrice = Decimal.valueOf((String)params.get('price'));
        } else {
        	unitPrice = null != params.get('unitPrice') ? (Decimal)params.get('unitPrice') : getPrice(pricebookEntryId);
        }
        
        quantity = null == params.get('quantity') ? 1.0 : theQuantity;
        
        firstName = null != params.get('firstName') ? (String)params.get('firstName') : null;
        
        lastName = null != params.get('lastName') ? (String)params.get('lastName') : null;
        
        email = null != params.get('email') ? (String)params.get('email') : null;
        
        contactId = (null != params.get('contactId') && ''!=(String)params.get('contactId')) ? (String)params.get('contactId') : getContactId(email);
        
        license = null != params.get('license') ? (String)params.get('license') : null;
        
        data = null != params.get('data') ? (String)params.get('data') : null;
    }
    
    public String getContactId(String email){
        if(null == email || '' == email.trim()) return null;
        List<Contact> c = [SELECT Id FROM Contact WHERE Email = :email];
        
        
        return null == c || c.size() == 0 ? null : c[0].Id;
    }
    
    public Boolean hasExistingSObject(){
        return this.opportunityLineItemId != null;
    }
    
    public Boolean needsUpdate(Id newPricebookEntryId){
        return (this.hasExistingSObject() && newPricebookEntryId != pricebookEntryId);
    }

    
    public Decimal getPrice(Id pricebookEntryId){
        return ClickpdxPricebookEntryManager.getPrice(pricebookEntryId);
    }
    
    public String getDescription(PricebookEntry entry){
        if(null == entry || null == entry.Product2){
            return 'OCDLA Product';
        }
		return entry.Product2.ClickpdxCatalog__LineDescription__c != null ? entry.Product2.ClickpdxCatalog__LineDescription__c : entry.Product2.Name;
    }
    
    public ClickpdxCartItem getJsonCompatible(){
        ClickpdxCartItem dup;
        String firstNameJson;
        String lastNameJson;
        
		firstNameJson = this.toJson(this.firstName);
        lastNameJson = this.toJson(this.lastName);
        dup = this.clone();
        dup.firstName = firstNameJson;
        dup.lastName = lastNameJson;
        
        return dup;
    }
    
    public String toJson(String source){
        String tmp;
        
        if(null == source){
            return null;
        }
        
        tmp = source.replaceAll('\n', '\\\\n');
                             
		return tmp;
    }
    
    
    public OpportunityLineItem getSObject(){
        
        OpportunityLineItem li = new OpportunityLineItem(
            Id = this.opportunityLineItemId,
            OpportunityId = opportunityId,
			ParentLineId__c  = parentLineId,
            PricebookEntryId = pricebookEntryId,
            FirstName__c = firstName,
            LastName__c = lastName,
            Email__c = email,
            OcdlaStateLicense__c = license,
            Contact__c = contactId,
            Product2Id = product2Id,
            UnitPrice = unitPrice,
            Quantity = quantity,
            Description = description,
            Data__c = data
        );
        
        return li;
    }
    
    public String getProductName(){
        String name;
        
        Product2 p = [SELECT Id, Name FROM Product2 WHERE Id = :this.product2Id];
        
        return null != p ? p.Name : '';
    }
    
    public Decimal getTotalPrice(){
        return (this.quantity * this.unitPrice).setScale(2);
    }
    
    public void save(){
        
        OpportunityLineItem li = this.getSObject();
        
        if(null == opportunityId){
            throw new ClickpdxShoppingCartException('Cannot save this Cart Item without a related Opportunity Id.');
        }

        upsert li;
        
        this.opportunityLineItemId = li.Id;
    }
    
    public static List<ClickpdxCartItem> saveAll(ClickpdxShoppingCart cart, List<ClickpdxCartItem> items){
        if(null == cart.getId()){
            throw new ClickpdxShoppingCartException('Items cannot be saved when ShoppingCart has no Id: CART_NO_ID_ERROR.');
        }
        Map<String,OpportunityLineItem> lines = new Map<String,OpportunityLineItem>();
        
        for(ClickpdxCartItem item :items){
            item.opportunityId = cart.getId();
            lines.put(item.key(), item.getSObject());
        }
        
        upsert lines.values();
        
        for(ClickpdxCartItem item :items){
            OpportunityLineItem line = lines.get(item.key());
            item.opportunityLineItemId = line.Id;
        }
        
        return items;
    }
    
    public class CartItemData {
        Boolean userCreated = null;
        
        Boolean userUpdated = null;
    }
    
    @TestVisible
    public Map<String,String> theDataset {public get{
        Map<String,String> theData = new Map<String,String>();
        if(null != this.data){
            try {
                theData = (Map<String,String>)JSON.deserialize(this.data, Map<String,String>.class);
            } catch(Exception e){
                theData.put('errors',e.getMessage());
            }
        }
                if(!theData.containsKey('userUpdated')){
                    theData.put('userUpdated','false');
                }
        if(!theData.containsKey('errors')){
            theData.put('errors','none');
        }
            
		return theData;
    }
        private set;
    }
    
    @TestVisible
    private String getClientId(){
        Integer len = 10;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,len);
    }
}