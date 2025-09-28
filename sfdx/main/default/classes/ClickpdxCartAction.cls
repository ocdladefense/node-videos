public class ClickpdxCartAction {
    
    public ClickpdxCartActionType action {public get; private set;}
    
    public Boolean hasErrors {public get; private set;}
    
    public String errors {public get; private set;}
    
    public Id opportunityLineItemId {public get; private set;}
    
    public String clientId {public get; private set;}
    
    public Id OpportunityLineItemParentId {public get; private set;}
    
    public PricebookEntry pricebookEntry {public get; private set;}
    
    public Decimal quantity {public get; private set;}
    
    public String firstName {public get; private set;}
    
    public String lastName {public get; private set;}
    
    public String email {public get; private set;}
    
    public String description {public get; private set;}
    
    public String data {public get; private set;}
    
    public Decimal salesPrice {public get; private set;}
    
    public Decimal donationAmount {public get; private set;}
    
    public String donationAmountParam {public get; private set;}


    public ClickpdxCartItem getAsCartItem(){
        ClickpdxCartItem cartItem = new ClickpdxCartItem();
        
        cartItem.description = this.pricebookEntry.Product2.Name;
        // No need to set client id as we are adding this product to the cart.
        cartItem.product2Id = this.pricebookEntry.Product2Id;
        // cartItem.contactId = null == theContact ? null : theContact.Id;
        cartItem.unitPrice = this.getPrice();
        cartItem.quantity = this.quantity;
        cartItem.totalPrice = this.getQuantity() * this.getPrice();
        cartItem.firstName = this.firstName;
        cartItem.lastName = this.lastName;
        cartItem.email = this.email;
        cartItem.data = this.data;

        cartItem.pricebookEntryId = this.pricebookEntry.Id;
        cartItem.description = this.description;
        
        return cartItem;
    }
    
    public ClickpdxCartItem getAsCartItem(ClickpdxShoppingCart cart){
        ClickpdxCartItem newCartItem = this.getAsCartItem();
        ClickpdxCartItem existing = this.getExistingCartItem(cart);
        
        if(null != existing){
            newCartItem.opportunityLineItemId = existing.opportunityLineItemId;
            newCartItem.clientId = existing.clientId;
            newCartItem.quantity += existing.quantity;
        }
        
        newCartItem.opportunityId = cart.getId();
        return newCartItem;
    }
    
    private static Map<String,Object> getDefaults(){
        Map<String,Object> defaults = new Map<String,Object>();
        defaults.put('opportunityLineItemId',null);
        defaults.put('clientId',null);
        defaults.put('pricebookEntry',null);
        defaults.put('quantity','1.0');
        defaults.put('firstName','');
        defaults.put('lastName','');
        defaults.put('email','');
        defaults.put('contactId',null);
        defaults.put('contact',null);
        
        return defaults;
    }
    
    private static void validateParams(Map<String,Object> passed){
        if(passed.get('opportunityLineItemId') == null && passed.get('pricebookEntryId')==null){
            throw new ClickpdxCartActionException('Cannot process cart action with missing opportunityLineItemId and pricebookEntryId.');
        }
    }
    
    private void initParams(Map<String,Object> params){
        Map<String,Object> defaults = getDefaults();
        
        for(String key :defaults.keySet()){
            if(params.get(key) == null){
				params.put(key,defaults.get(key));
            }
        }
        
        ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager();

        
        try {
            validateParams(params);

            opportunityLineItemId = (String)params.get('opportunityLineItemId');
            
            clientId = (String)params.get('clientId');
            
            Id pricebookEntryId = (Id)params.get('pricebookEntryId');
            
            quantity = Decimal.valueOf((String)params.get('quantity'));
            
            firstName = (String)params.get('firstName');
        
            lastName = (String)params.get('lastName');
            
            email = (String)params.get('email');
            
            donationAmountParam = null == params.get('price') ? null : (String)params.get('price');
            
            donationAmount = (null == donationAmountParam || '' == donationAmountParam.trim()) ? null : Decimal.valueOf(donationAmountParam);
            
            data = (null == params.get('data') || '' == params.get('data')) ? null : (String)params.get('data');
            
            pricebookEntry = manager.entry(pricebookEntryId);
            if(null == pricebookEntry) throw new ClickpdxShoppingCartException('Cannot convert params to Cart Action: MISSING_PRICEBOOK_ENTRY.');
            
            salesPrice = pricebookEntry.UnitPrice;
            
        } catch(Exception e){
            this.addError(e);
        }
    }
    
    
    public Boolean isExistingCartItem(ClickpdxShoppingCart cart){
        
        return null != this.getExistingCartItem(cart);
    }
    
    public ClickpdxCartItem getExistingCartItem(ClickpdxShoppingCart cart){
        ClickpdxCartItem foundItem = null;
        
        for(ClickpdxCartItem item : cart.getItems().values()){
            if(this.pricebookEntry.Id == item.pricebookEntryId && this.data == item.data){
                return item;
            }
        }
        
        return foundItem;
    }
 
    
    public ClickpdxCartAction(ClickpdxCartActionType type, Product2 prod){
        ClickpdxPricebookEntryManager prodInfo = new ClickpdxPricebookEntryManager(prod);
        
        Map<String,Object> params = new Map<String,Object>();
        params.put('pricebookEntryId',prodInfo.productEntry(prod.Id).Id);

		action = type;
        hasErrors = False;
            
		initParams(params);
    }
    
    public ClickpdxCartAction(ClickpdxCartActionType type, Map<String,Object> params) {
		action = type;
        hasErrors = False;
            
		initParams(params);
    }
    
    public void setPricebookEntry(PricebookEntry entry){
        this.pricebookEntry = entry;
    }
    
    public Decimal getQuantity(){
        return this.quantity;
    }
    public Decimal getPrice(){
        return donationAmount != null ? donationAmount : ClickpdxPricebookEntryManager.getPrice(this.pricebookEntry.Id);
    }
    
    public Decimal getTotalPrice(){
        return this.getPrice() * this.quantity;
    }
    
    private void addError(Exception e){
        this.hasErrors = True;
        this.errors = e.getMessage();
    }
    
    public Boolean isValid(){
        return this.hasErrors == False;
        /*
        if(!alreadyInCart && False){//this.isDuplicateCartItem(cartItem)){
            throw new ClickpdxShoppingCart.ClickpdxShoppingCartException('You already have this item for '+entry.Product2.Name+' in your shopping cart (Opportunity Product Id is: '+cartItem.ids+'.');
        }
        */
                // ClickpdxShoppingCartPermission.checkPermissionSchemesAll(entry, email, data);
                // 
                // //         Boolean alreadyInCart;
    }


    
    
    public void doCartAction(ClickpdxShoppingCart cart){

        // @var affectedItem
        // The returned cart item with information about the item filled-in.
        // This can be returned as part of responseData so the client can use it for post-processing.
        ClickpdxCartItem affectedItem;
        
        // @var theProduct
        // The Product2 object just added to the cart.
        Product2 theProduct;
        
        // @var entry
        // The PricebookEntry added to the cart.
        PricebookEntry entry;
        
        // @var actionData
        // A Map of data related to adding an item to this cart.
        Map<String,Object> actionData = new Map<String,Object>();		
        
        // @var related
        // A Map of Products related to the Product currently being added.
        // Map<Id,ClickpdxRelatedProduct> related;
        
        // @var inCart
        // A List of Items in this Cart that are already related items to the Product being added.
        List<OpportunityLineItem> inCart;
        
        // Variables when adding related Products.
        String pricebookEntriesJson;
        
        String opportunityLineItemParentId;
        
        // Map<Id,ClickpdxRelatedProduct> relatedProducts;

        
        // actionData.put('pricebookEntryId',params.get('pricebookEntryId'));
        // actionData.put('quantity',params.get('quantity'));
        // actionData.put('clientId',params.get('clientId'));
        
        
        /*
        try {
            if('add' == cartAction){
				String thePricebookEntryId = (String)params.get('pricebookEntryId');
                if(null != entry.Product2.ProrationType__c){
                    actionData.put('prices', new ProrationRule[]{new ProrationRule(entry.Product2.ProrationType__c,entry.UnitPrice)});
                }
                affectedItem = ClickpdxShoppingCartAddToCartAction.addItems(cart,thePricebookEntryId);
                affectedItem.save();
                
                cart.cartItems.put(affectedItem.ids, affectedItem);                
            }
            
            else if('addRelatedItems' == cartAction){
                pricebookEntriesJson = params.get('pricebookEntries');
                relatedProducts = (Map<Id,RelatedProduct>)JSON.deserialize(pricebookEntriesJson,Map<Id,RelatedProduct>.class);
                opportunityLineItemParentId = (String)params.get('opportunityLineItemParentId');
                
                Map<Id,List<String>> relatedForms = this.addRelatedItems(relatedProducts,opportunityLineItemParentId);
                ClickpdxShoppingCartInvalidFormException ex = new ClickpdxShoppingCartInvalidFormException();
                
                if(relatedForms.size() > 0){
                    for(Id entryId :relatedForms.keySet()){
                        actionData.put('pricebookEntryId',entryId);
                        actionData.put('quantity',params.get('pricebookEntryId'));
                        actionData.put('opportunityLineItemParentId',params.get('opportunityLineItemParentId'))
                        // actionData.put('clientId',params.get('clientId'));
                        ex.addForms(relatedForms.get(entryId));
                    }
                    throw ex;
                }
            } 
            
            else if('removeItem' == cartAction){
                String opportunityLineItemId = params.get('opportunityLineItemId');
                ClickpdxCartItem forRemoval;
                
                // For now, just remove the specified cart Item.
                // In the future, we may want to identify related cart Items
                //   and remove them, too.
                forRemoval = this.cartItems.remove(opportunityLineItemId);
                forRemoval.del();
                actionData.put('object',forRemoval);// TODO eventually delete this - it's redundant.
                if(null == affectedItem){
                    throw new ClickpdxShoppingCartException('CartItem with client id, '+opportunityLineItemId+', cannot be located in the Shopping Cart.');
                }
			                
            } else if('persist' == cartAction){
                
                String userAgent = (null != params.get('userAgent') && (String)params.get('userAgent').trim() != '') ? (String)params.get('userAgent') : 'Unknown';
                
                saveCartSObject(userAgent);
                
            } else if('checkout' == cartAction){
                PageReference checkout = OrgOcdla.CHECKOUT_PAGE;
                
                if(null != checkout){
                    checkout.setRedirect(true);
                    checkout.getParameters().put('id',getShoppingCartId());
                }
                
                return checkout;
            }
            */
            
        /*
            related = null == affectedItem ? null : getRelatedProducts(affectedItem.product2Id);
            
            inCart = null != related && 0 < related.size() ? getRelatedProductsInCart(affectedItem, related.keyset()) : new List<OpportunityLineItem>();
            
            actionData.put('action',cartAction);
            actionData.put('item',affectedItem);
            
            if(cartAction != 'addRelatedItems') {
                actionData.put('relatedProducts',null == related ? null : related.values());
                actionData.put('relatedProductsInCart',inCart);
            }
            // actionData.put('event',evt);
            
        } catch(ClickpdxShoppingCartInvalidFormException e){   
			actionData.putAll(getErrorActionData(e));
            actionData.put('productForms',e.forms);
        } catch(Exception e){
			actionData.putAll(getErrorActionData(e));
        }
*/
        
        // setToJson(actionData);

    }
    
	/*
    public Map<Id,List<String>> addRelatedItems(Map<Id,RelatedProduct> relatedProducts, String opportunityLineItemParentId){
        List<ClickpdxCartItem> forAddition = new List<ClickpdxCartItem>();
        List<OpportunityLineItem> forDelete = new List<OpportunityLineItem>();
		Map<Id,List<String>> forms = new Map<Id,List<String>>();
        
        if(null == opportunityLineItemParentId || opportunityLineItemParentId.trim() == ''){
            return null;
        }
        
        
        // Do a clean remove of any existing children.  This is easier than determining which have changed.
        // Delete any existing cart items with the given parent Id
        forDelete.addAll(ClickpdxCartItem.deleteChildren(opportunityLineItemParentId));
        
        for(OpportunityLineItem li: forDelete){
            this.cartItems.remove(li.Id);
        }
        
        for(RelatedProduct r :relatedProducts.values()){
            ClickpdxCartItem theCartItem;
            PricebookEntry entry = getPricebookEntry(r.PricebookEntryId);
            
            try {
                theCartItem = this.addToCartBase(entry,new Map<String,String>{'pricebookEntryId'=>entry.Id});
                theCartItem.parentLineId = opportunityLineItemParentId;
                theCartItem.quantity = r.Quantity;
                theCartItem.description = r.LineDescription;
                theCartItem.unitPrice = r.UnitPrice;
                    
                theCartItem.save();
                
                this.cartItems.put(theCartItem.ids, theCartItem);
                forAddition.add(theCartItem);
                
            } catch(ClickpdxShoppingCartInvalidFormException e){   
                // actionData.putAll(getErrorActionData(e));
           		// ClickpdxShoppingCartInvalidFormException ex = new ClickpdxShoppingCartInvalidFormException('Please complete the following information.');
            	// ex.addForms(entry.Product2.Forms__c);
                forms.put(entry.Id,e.forms);
            }
        }
        
        if(null != forAddition && 0 < forAddition.size()){
            // insert forAddition;
        }
        
        return forms;
    }
    */
    
    public class ClickpdxCartActionException extends Exception {}
}