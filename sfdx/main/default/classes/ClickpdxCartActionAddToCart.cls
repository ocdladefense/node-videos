public class ClickpdxCartActionAddToCart {


    public static List<ClickpdxCartItem> doAction(ClickpdxShoppingCart cart, List<Map<String,Object>> allParams){

        ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager();
        List<ClickpdxCartItem> affectedItems = new List<ClickpdxCartItem>();
        List<ClickpdxCartItem> newItems = new List<ClickpdxCartItem>();


        
        for(Map<String,Object> params :allParams){
            ClickpdxCartItem newItem = new ClickpdxCartItem(params);
            ClickpdxCartItem previousItem = cart.getItem(newItem.key());
            
            if(!MembersOnlyAccess.hasAccess(newItem)){
                throw new ClickpdxShoppingCartException('This is a members-only product.');
            }
            if(newItem.hasForms() && !newItem.hasFormsData()){
                ClickpdxShoppingCartInvalidFormException xform = new ClickpdxShoppingCartInvalidFormException('Please complete the following information.');
                xform.setProduct(newItem);
                throw xform;
            }
            String clientId = (String)params.get('clientId');
            
            if(null != previousItem && clientId != newItem.clientId){
                throw new ClickpdxShoppingCartException('The returned client id does not match.');
            }
            
            if(null != previousItem && newItem.needsUpdate(previousItem.pricebookEntryId)){
                
                cart.removeItem(previousItem);
                previousItem.del();
                newItem.clientId = clientId;
                newItem.opportunityLineItemId = null;
            }

            affectedItems.add(newItem);
        }
        

        
        ClickpdxCartItem.saveAll(cart,affectedItems);
        
        for(ClickpdxCartItem item :affectedItems){
        	cart.addItem(item);
            // throw new ClickpdxShoppingCartException('After adding item could not retrieve it from the ClickpdxCartItem List.');
        }

        return affectedItems;
    }

    
    
    
    public static List<ClickpdxCartItem> doAction(ClickpdxShoppingCart cart, Map<String,Object> params){
        return doAction(cart, new List<Map<String,Object>>{params});
    }
    

    public static List<ClickpdxCartItem> addProducts(ClickpdxShoppingCart cart, List<Id> pricebookEntryIds){
        
        List<Map<String,Object>> allParams = getParameters(pricebookEntryIds);
        
        return doAction(cart, allParams);
    }
    
    

    
    public static List<ClickpdxCartItem> addProducts(ClickpdxShoppingCart cart, List<Product2> products){
        ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(products);
        
		List<Map<String,Object>> allParams = new List<Map<String,Object>>();
        
        for(Product2 prod :products){
			PricebookEntry entry = manager.productEntry(prod.Id);
            allParams.add(getParameters(entry)[0]);
        }
        
       	return doAction(cart, allParams);
    }
    

    

    
    public static ClickpdxCartItem addToCart(ClickpdxShoppingCart cart, PricebookEntry entry, Contact c){
        List<Map<String,Object>> params = getParameters(entry,c);
        
       	List<ClickpdxCartItem> items = doAction(cart, params);
        
        return items[0];
    }

 
    
    
    private static List<Map<String,Object>> getParameters(PricebookEntry entry, Contact c){
        List<Map<String,Object>> allParams = new List<Map<String,Object>>();
        
        Map<String,Object> params = new Map<String,Object>();
        
        
        params.put('pricebookEntry',entry);
        params.put('pricebookEntryId',entry.Id);
        params.put('firstName',c.FirstName);
        params.put('lastName',c.LastName);
        params.put('email',c.Email);
        params.put('contactId',c.Id);
        params.put('contact',c);
        params.put('quantity',1.0);
        // params.put('license',c.OcdlaStateLicense__c );
        // 
        allParams.add(params);
        
        return allParams;
    }


    private static List<Map<String,Object>> getParameters(PricebookEntry entry){
        List<Map<String,Object>> allParams = new List<Map<String,Object>>();
        
        Map<String,Object> params = new Map<String,Object>();
        
        
        params.put('pricebookEntry',entry);
        params.put('pricebookEntryId',entry.Id);
        params.put('quantity',1.0);

        allParams.add(params);
        
        return allParams;
    }
    
    
    private static List<Map<String,Object>> getParameters(List<Id> pricebookEntryIds){
        List<Map<String,Object>> allParams = new List<Map<String,Object>>();
        
        ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager(pricebookEntryIds);
        
        for (Id entryId :pricebookEntryIds){
            Map<String,Object> params = new Map<String,Object>(); 
            params.put('pricebookEntryId',entryId);
            params.put('quantity',1.0);
            
            allParams.add(params);
        }
        
        
        return allParams;
    }
    
    
    
    public Product2 toProduct(String pricebookEntryId){
        PricebookEntry entry = [SELECT Product2Id FROM PricebookEntry WHERE Id = :pricebookEntryId];
        return new Product2(Id=entry.Product2Id);
    }
    
    
    
    public static Boolean isDuplicateGrant(ClickpdxShoppingCart cart, PricebookEntry entry){
        // if(null == theLine.contactId) return False;
        Id oppId = cart.cartId;
        for(OpportunityLineItem li :[SELECT Id, PricebookEntry.Product2.GrantValue__c FROM OpportunityLineItem WHERE OpportunityId = :oppId]){
            if(null != li.PricebookEntry.Product2.GrantValue__c) return True;
        }
        return False;
    }
    


    
}