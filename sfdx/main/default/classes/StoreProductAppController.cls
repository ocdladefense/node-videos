global virtual class StoreProductAppController {
    
    protected Map<String,List<OrderApi__Item__c>> groups = new Map<String,List<OrderApi__Item__c>>();
     
    public String errorMessage	{ get; set; }
   
    public String debugMessage	{ get; set; } 
    
    protected String PRODUCT_GROUPS_FIELD_NAME;
    
	static final String SALESFORCE_MULTIPICKLIST_SEPARATOR = ';';
    
    // A generic key for a product group that will always reference all queried products,
    // no matter their category.
    static final String KEY_ALL_PRODUCTS = 'ALL_PRODUCTS';
    
	protected String APP_PRODUCT_QUERY;
    
	// The List of Items available on this controller's instance.
	protected List<OrderApi__Item__c> products;
    
    public String[] productsSelected		{ get; set; }
    public List<SelectOption> productOptions {get;private set;}
    
    public Boolean hasProducts;
    
	public Boolean hasError;
    
    
    
    public StoreProductAppController(){}
    
    protected StoreProductAppController(String appQuery){
        APP_PRODUCT_QUERY = appQuery;
    }
    
    protected void loadProducts(String appQuery){
        APP_PRODUCT_QUERY = appQuery;
        products = Database.query(APP_PRODUCT_QUERY);
		this.addItems(products,KEY_ALL_PRODUCTS);
        // By default there should always be a group with the key,
        // KEY_ALL_PRODUCTS that stores all of the products.
        products = this.getItemGroup(KEY_ALL_PRODUCTS);
        
        productOptions =  toSelectOptions(products);
        productsSelected = new String[]{};
            
        this.groupProducts();
    }
    
    
    
    protected virtual void groupProducts(){
        for(OrderApi__Item__c item : this.products){
            String[] itemGroups = parseProductGroups(item);
            if(itemGroups.size() > 0) this.addToGroups(itemGroups, item);
        }
    }
    

    
    protected virtual void initProductLists(String selectedSubCategory){

    }
    
    public Boolean getHasProducts(){
        return products.size() > 0;
    }
    
    protected virtual SelectOption toSelectOption(sObject item, Boolean disabled) {
        String price = (Decimal)item.get('OrderApi__Price__c') == 0 ? 'N/A' : '$'+(Decimal)item.get('OrderApi__Price__c');
        SelectOption opt = new SelectOption((String)item.get('Id'), (String)item.get('OrderApi__Display_Name__c') + ' - ' + price);
        opt.setDisabled(disabled);
        return opt;
    }

    protected List<SelectOption> toSelectOptions(List<sObject> theList){
        Boolean NOT_DISABLED = False;
        return toSelectOptions(theList, NOT_DISABLED);
    }
    
    protected List<SelectOption> toSelectOptions(List<sObject> theList, Boolean isDisabled){
        List<SelectOption> options = new List<SelectOption>();
        
        for(sObject item : theList){
            options.add(toSelectOption(item, isDisabled));
        }
        
        return options;
    }

    
    public Boolean getHasError(){
        return !String.isBlank(errorMessage);
    }
    
    protected String[] getSelectOptionValues(List<SelectOption> options){
        String[] values = new String[]{};
       
        for(SelectOption o : options){
            values.add(o.getValue());
        }
        
        return values;
    }

    
    

    
    protected List<sObject> excludeFromGroup(List<sObject> theGroup, String filterOut){
        Integer index = 0;
        List<sObject> removed = new List<sObject>();
        
        while(index < theGroup.size()){
            String assignedGroups = (String)theGroup.get(index).get('Clickpdx_External_App_Tags__c');
            if(picklistContains(assignedGroups, filterOut)){
                removed.add(theGroup.remove(index));
            }
            else index++;
        }
        
        return removed;
    }
    
    protected String[] parseProductGroups(sObject o){
        String tmp;
        
        tmp = (String)o.get(PRODUCT_GROUPS_FIELD_NAME);
        if(null == tmp) return new String[]{};
        
        return tmp.split(SALESFORCE_MULTIPICKLIST_SEPARATOR);
    }
    
    
    
    protected void addToGroups(String[] groupNameList, OrderApi__Item__c item){
        for(String groupName: groupNameList){
            this.addItems(new List<sObject>{item}, groupName);
        }
    }
    
    protected void addItem(OrderApi__Item__c theItem, String groupName){
        this.addItems(new List<OrderApi__Item__c>{theItem},groupName);
    }
    
    protected virtual void addItems(List<OrderApi__Item__c> theItems, String groupName){
        List<OrderApi__Item__c> groupList;
        
        if(null == groups.get(groupName)){
			groupList = addItemGroup(groupName, createItemGroup());
        }
        else groupList = getItemGroup(groupName);
        
        groupList.addAll(theItems);
    }
    
    protected virtual List<OrderApi__Item__c> addItemGroup(String groupName, List<OrderApi__Item__c> theGroup){
        if(null != groups.get(groupName)){
            throw new ClickpdxAppException('Error when creating Item Group, '+groupName+': Group Name already exists.');
        }
		groups.put(groupName, theGroup);
        return theGroup;
    }
    
    protected virtual List<OrderApi__Item__c> createItemGroup(){
        return new List<OrderApi__Item__c>();
    }
     
    protected virtual List<OrderApi__Item__c> getItemGroup(String groupName){
        return this.groups.containsKey(groupName) ? this.groups.get(groupName) : createItemGroup();
    }
 
    
    public static Boolean picklistContains(String delineated, String compare){
        Set<String> multiselectValues = new Set<String>();
        multiSelectValues.addAll(delineated.split(SALESFORCE_MULTIPICKLIST_SEPARATOR));
        
        return multiSelectValues.contains(compare);
    }

    
    public virtual pageReference Checkout() {
        return null;
    }


    
}