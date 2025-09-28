global without sharing class OcdlaMembershipAppController extends StoreProductAppController {
    
      
    private static final Boolean DISPLAY_MEMBERSHIP_OPTIONS = True;
    
    public static final String IS_APP_AVAILABLE_FIELD_NAME = 'Clickpdx_External_App_Is_Active__c';
    
    public static final String CATEGORY_FIELD_NAME = 'Clickpdx_External_App_Tags__c';

    public static final String PRODUCT_OPTION_FLAG = 'Option';
    
    // Where a "Back" or "Previous Step" button, if any, should take the user.
    private final String APP_PREVIOUS_STEP_PAGE_REFERENCE = '';
    
    public String myTotal;
    
    public String selectedMemTypeId {get; set;}
    
    public String selectedSubCategory; 
    
    public List<OrderApi__Item__c> selectedOptionsList	{ get; set; }
    
    public Id contactId {get;set;}
    
    public Id accountId {get;set;}
    
    
	// Probably want to deprecate these.
    public String[] directoryItemsSelected = new String[]{};
    public List<SelectOption> directoryOptions {get;private set;}
    
    public String[] donationItemsSelected {get;set;}
    public List<SelectOption> donationOptions {get;private set;}
    
    
    
    public OcdlaMembershipAppController() {
        super();
        
        // Any paramters passed to this page.
        Map<String,String> pageParams;
        
        String query = 'SELECT Id, Name,' +CATEGORY_FIELD_NAME +
            ', OrderApi__Display_Name__c, OrderApi__Price__c FROM OrderApi__Item__c'+
            ' WHERE  '+IS_APP_AVAILABLE_FIELD_NAME+ ' = True';
        this.PRODUCT_GROUPS_FIELD_NAME = CATEGORY_FIELD_NAME;
        
        try {
            this.loadProducts(query);
        
        	// Define a group for Donations.
        	List<OrderApi__Item__c> donations = this.getItemGroup('Donations');
        	donations.add(this.products[0].clone(True));
        	donationOptions =  toSelectOptions(donations);
        	donationItemsSelected = new String[]{};
            
            pageParams = ApexPages.CurrentPage().getParameters();
            
            accountId = pageParams.get('accid');
            contactId = pageParams.get('conid');
            
            selectedSubCategory = pageParams.get('subcategory');
            
        } catch(Exception e){
            errorMessage = e.getMessage();
            debugMessage = 'TRACE ==> '+e.getStackTraceString();
        }
    }  

    
/*
 * Uncomment if you wish augment the default functionality, which is to list all products available to this Application.  
    public override void initProductLists(String selectedSubCategory){
        Integer membershipCounter;
        Integer addOnCounter;
        List<OrderApi__Item__c> memberships;
        List<OrderApi__Item__c> options;
        List<OrderApi__Item__c> packaged;
        
        membershipCounter = 0;
        addOnCounter = 0;
        
        
        memberships = this.getItemGroup(selectedSubCategory);
        options = this.getItemGroup('Option');
        packaged = this.getItemGroup('Operator Packaged');
        
        // For uncategorized Accounts, display available Operator and Vendor membership products.
        if(selectedSubCategory == null){
            memberships.addAll(this.getItemGroup('Operator'));
            memberships.addAll(this.getItemGroup('Vendor'));
        }

       	// Filter out Options from Memberships, proper.
        this.excludeFromGroup(memberships, 'Option');

        
        for (OrderApi__Item__c item : memberships){
            mtWrapperList.add(new ProductWrapper(item)); 
            if(membershipCounter == 0) selectedMTList.add(item);
            membershipCounter++;            
        }
        
        membershipAddOnOptions =  toSelectOptions(options);
        membershipAddOns = new String[]{};
        
		Boolean IS_DISABLED = True;
        packagedAddOnsOptions = toSelectOptions(packaged, IS_DISABLED);
		packagedAddOns =  getSelectOptionValues(packagedAddOnsOptions);
        
    }
*/
    
    
    
    /*
    protected override void execute(){
        List<OrderApi__Item__c> items = Database.query(APP_PRODUCT_QUERY);
        for(OrderApi__Item__c item : items){
            String[] itemGroups = parseProductGroups(item);
            this.addToGroups(itemGroups, item);
        }
    }
	*/
    
    /**
     * Uncomment to override how Products are rendered on the page.
     * 
     */
    /**
    protected override SelectOption toSelectOption(sObject item, Boolean disabled) {
        // The object that will be returned.
        SelectOption opt;
        
        // The formatted price to be displayed as part of the SelectOption.
        String price;
        
        price = (Decimal)item.get('OrderApi__Price__c') == 0 ? ' - N/A' : ' - $'+(Decimal)item.get('OrderApi__Price__c');
        price = disabled || PRODUCT_DISPLAY_NO_PRICE ? '' : price;
        
        opt = new SelectOption((String)item.get('Id'), (String)item.get('OrderApi__Display_Name__c') + price);
        opt.setDisabled(disabled);
        return opt;
    }
	*/
    
    public String getSelectedSubCategory(){
        return this.selectedSubCategory == null ? '' : this.selectedSubCategory;
    }
    
    private String getMembershipSubCategory(String selectedMembershipId){
        if(null == selectedMembershipId) return null;
		String query = 'SELECT '+CATEGORY_FIELD_NAME +'  FROM OrderApi__Item__c WHERE Id = \''+selectedMembershipId+'\'';
        
        List<OrderApi__Item__c> items = Database.query(query);
        if(null == items || items.size() < 1) return null;
        
        return (String)items.get(0).get(CATEGORY_FIELD_NAME);
    }

    

    

    
    private static String getSObjectTags(sObject item){
        return (String)item.get(CATEGORY_FIELD_NAME);
    }

    
    public PageReference test(){
        return null;
    }

    
    public String getMyTotal() {
        return '';
    }
    
    public String[] getDonationsSelected(){
        return donationItemsSelected; 
    }
    
    public void setDonationsSelected(String[] donationItemsSelected){
        this.donationItemsSelected = donationItemsSelected;
    }
    
    public PageReference updateMembership(){
        // this.membershipAddOnOptions.clear();
        this.selectedMemTypeId = System.currentPagereference().getParameters().get('selectedMembershipId');
		this.selectedSubCategory = this.getMembershipSubCategory(this.selectedMemTypeId);
		// this.initProductLists(this.selectedSubCategory);
        
        return null;
    }
    
    
    public PageReference updateMembershipAddOns(){
        // This should be a String of membership add ons Ids.
		String selectedMembershipAddOns;
        
        selectedMembershipAddOns = System.currentPagereference().getParameters().get('selectedMembershipAddOns');
        return null;
    }

        
/**
* 
* @method Save
*
* @description 
* 		Save, in this order:
*			 - The Account
*				- The Contact
*				- The Sales Order
*  Advance the user to a confirmation page; otherwise remain on the current page
*	and show any relevant errors.
*
**/
    public override pageReference Checkout() { 
        // Let's backup our database and rollback if we have any errors
        Savepoint sp = Database.setSavepoint(); 
        
        // Where to redirect if there are errors.
        PageReference errorNoRedirect = new PageReference(ApexPages.currentPage().getUrl());
        errorNoRedirect.setRedirect(True);
        
        // Primary membership(s) to attach to this Sales Order.
        List<String> membershipIds = new List<String>{selectedMemTypeId};
            
            // Secondary, "Add-on" products to attach to this Sales Order.
            // this.membershipAddOns
            
            // Reference to the Checkout page where the customer can pay for their order
            // without being logged-in.
            PageReference proFormaRedirect = Page.OrderApi__checkout;
        
        // Our OrderApi__Sales_Order__c wrapper class with convenience methods.
        ClickpdxMembershipSalesOrder theOrder;
        
        // Whether this is a complimentary purchase.
        Boolean isComplimentary = False;
         
       	Id theSalesOrderContactId;
        
        try
        {
	        if(accountId == null) throw new ClickpdxAppException('Cannot create a Sales Order for a null Account');
            
            theOrder = new ClickpdxMembershipSalesOrder(new Contact(Id=contactId),new Account(Id=accountId));
			theSalesOrderContactId = theOrder.getSalesOrderContact();
            
            if (membershipIds.size() <= 0) { 
                throw new ClickpdxAppException('No membership Ids were passed to this method.');
            } 
            
            if(membershipIds[0] == null){
                throw new ClickpdxAppException('The membership Item Id passed to this form is Null.');
            }
            
            // Add the main Membership product.
            theOrder.addLineItem(membershipIds[0], contactId == null ? null : new Contact(Id=contactId));
            
            
            // Now add any necessary Membership or Add-on products.
            // theOrder.addLineItems(this.membershipAddOns);
            
            // Save the Sales Order		
            theOrder.save();
            
            proFormaRedirect.getParameters().put('salesOrder',theOrder.getId());
            proFormaRedirect.getParameters().put('authreq','false');
            proFormaRedirect.getParameters().put('signedInAsGuest','true');
            proFormaRedirect.setRedirect(true);
            return proFormaRedirect; 
        }
        catch(Exception e)
        {
        	errorMessage = e.getTypeName() + ': '+e.getMessage();
        	debugMessage = e.getStackTraceString();
            Database.rollback(sp);

            errorNoRedirect.getParameters().put('accid',accountId);
            errorNoRedirect.getParameters().put('conid',contactId);
            errorNoRedirect.getParameters().put('subcategory',selectedSubCategory);
            return errorNoRedirect;
        }
    }
    

    
    
    public Pagereference previous(){
        PageReference back = new PageReference(APP_PREVIOUS_STEP_PAGE_REFERENCE);
        back.getParameters().put('subcategory',selectedSubCategory);
        back.setRedirect(true);
        return back;
    }
    
    
    public pagereference tempMethod(){
        return null;
    }

    
}