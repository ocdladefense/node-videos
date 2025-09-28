public class ClickpdxStoreItem {
    private sObject dbObject	{ get; set; }
    
    public Boolean selected  { get; set; }
    
	static final String SALESFORCE_MULTIPICKLIST_SEPARATOR = ';';    
    
    public static final String CATEGORY_FIELD_NAME = 'Clickpdx_External_App_Tags__c';
    
    private Set<String> tags;

    
    

/*    
    public static Boolean hasMembersOnlyAccessPermission(OrderApi__Item__c theItem){
        Id existingBadgePermission = null;
        List<OrderApi__Access_Permission__c> itemPermissions = new List<OrderApi__Access_Permission__c>(); 
        // Check if the Item already has the appropriate Access Permission
        itemPermissions = [SELECT Id, ORDERAPI__BADGE_TYPE__C, ORDERAPI__ITEM__C FROM OrderApi__Access_Permission__c
                           WHERE ORDERAPI__ITEM__C = :theItem.Id AND OrderApi__Badge_Type__c = :OrgOcdla.membersOnlyBadge];
        
        return (null != itemPermissions && itemPermissions.size()>0);
    }
*/
    
    public static Map<Id,Id> existingMembersOnlyBadgeAccessPermissions(List<OrderApi__Item__c> theItems){
        Map<Id,Id> existingBadgePermissions = new Map<Id,Id>();
        
        List<OrderApi__Access_Permission__c> itemPermissions = new List<OrderApi__Access_Permission__c>(); 
        
        // Check if the Item already has the appropriate Access Permission
        itemPermissions = [SELECT Id, ORDERAPI__BADGE_TYPE__C, ORDERAPI__ITEM__C FROM OrderApi__Access_Permission__c
                           WHERE ORDERAPI__ITEM__C IN (SELECT Id FROM OrderApi__Item__c WHERE Ocdla_Members_Only__c = True
							AND Id IN :theItems) AND OrderApi__Badge_Type__c = :OrgOcdla.membersOnlyBadge];
        
        for(OrderApi__Access_Permission__c p :itemPermissions){
			existingBadgePermissions.put(p.OrderApi__Item__c,p.Id);
        }
        
        return existingBadgePermissions;
    }
    
    
    public ClickpdxStoreItem(Map<String,Object> values){
        this.dbObject = new OrderApi__Item__c();
        
    	for (String field : values.keySet()) {
        	this.dbObject.put(field, values.get(field));
        }
    }

    /**
     * Example code:
     * Account a = (Account) init(new Account(), new Map<SObjectType, Object> {
	Account.Name => 'Acme',
	Account.BillingCity => 'San Francisco'
	});
	*/
    public ClickpdxStoreItem(Map<SObjectField, Object> values){
        this.dbObject = new OrderApi__Item__c();
        
    	for (SObjectField field : values.keySet()) {
        	this.dbObject.put(field, values.get(field));
        }
    }

    
    public ClickpdxStoreItem(sObject o){
        this.dbObject = o;
        this.selected = False;
        this.tags = toSet((String)o.get(CATEGORY_FIELD_NAME));
    }
    
    private Set<String> toSet(String picklistValues){
        return new Set<String>(picklistValues.split(SALESFORCE_MULTIPICKLIST_SEPARATOR));
    }
    
    public static Boolean picklistContains(String delineated, String compare){
        Set<String> multiselectValues = new Set<String>();
        multiSelectValues.addAll(delineated.split(SALESFORCE_MULTIPICKLIST_SEPARATOR));
        
        return multiSelectValues.contains(compare);
    }
        
    public void addTag(String tag){
        this.addTags(new List<String>{tag});
    }
    
    public void addTags(List<String> tags){

    }
    
    public Object get(String fieldName){
        return this.dbObject.get(fieldName);
    }
    
    private Object set(String fieldName, Object value){
    	Object tmp = this.dbObject.get(fieldName);
        this.dbObject.put(fieldName, value);
        return tmp;
    }
}