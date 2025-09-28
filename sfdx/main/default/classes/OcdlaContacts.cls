public class OcdlaContacts {

    public String previousMembershipStatus;
    
    public Date previousExpirationDate;
    
    public Id previousOrderId;
    
    public Id previousOrderLineId;
    
    public String previousProductName;
    
    public Date previousProductPurchaseDate;
    
    public String sObjectType;
    
    public Id sObjectId;
    
    public OcdlaContacts(){}
    
    private static String relatedAddressSObjectName = 'RelatedAddress__c';
    
    /**
     * 
     * @method, syncToRelatedAddress
     * 
     * @description, create a List or Related Address records for each passed Contact.
     * 
     * @param - List<Contact>, the List of Contacts for which to create related address records.
     * 
     * @op - <upsert>, related address records should be upserted; if no related address "primary record" exists,
     *   then 
     */
    public static void syncToRelatedAddresses(List<Contact> cList, ClickpdxTriggerManager.ClickpdxTrigger t){
        List<sObject> aInsertList = new List<sObject>();
        List<sObject> aUpdateList = new List<sObject>();
        
        Map<Id,sObject> existMap = new Map<Id,sObject>();
		Map<String,Schema.SObjectType> cache = Schema.getGlobalDescribe();
        
        Map<String,String> fieldMap;
        Schema.SObjectType sObjectToken;
        
        fieldMap = t.data.get('fieldMap');
        
		relatedAddressSObjectName = t.data.get('relatedSObject').get('SObjectName');
        
        String query = getRelatedAddressQuery(t);
        existMap = getExistingPrimaryAddresses(cList,query);
        
        sObjectToken = cache.get(relatedAddressSObjectName);
        
        if(null == sObjectToken){
			throw new OcdlaContactsException('Cannot generate a related record for unknown SObject: '+relatedAddressSObjectName);
        }
            
            
        for(Contact c :cList){
			sObject rec = sObjectToken.newSObject();
            
            for(String cField :fieldMap.keySet()){
                rec.put(fieldMap.get(cField),c.get(cField));                
            }
            
            if(null == existMap.get(c.Id)){
                rec.put('IsPrimary__c',True);
                aInsertList.add(rec);
            } else {
                rec.Id = existMap.get(c.Id).Id;
            	aUpdateList.add(rec);
            }

        }
        
        insert aInsertList;
        update aUpdateList;
    }


    private static Map<Id,sObject> getExistingPrimaryAddresses(List<Contact> cList, String query){
		List<sObject> existList = new List<sObject>();
        Map<Id,sObject> existMap = new Map<Id,sObject>();
        // 'SELECT Id, Contact__c FROM RelatedAddress__c WHERE Contact__c = :cList AND IsPrimary__c = True'
        existList.addAll(Database.query(query));
        
        for(sObject o :existList){
			existMap.put((Id)o.get('Contact__c'),o);
        }
        
        return existMap;
    }
    
    private static String getRelatedAddressQuery(ClickpdxTriggerManager.ClickpdxTrigger t){
        String[] fieldList = new String[]{};
        String sObjectName;
        String selectClause;
        String query;
        String contactKeyField;
        
        fieldList.add('Id');
        fieldList.addAll(t.data.get('fieldMap').values());
        selectClause = String.join(fieldList,',');
        sObjectName = t.data.get('relatedSObject').get('SObjectName');
        contactKeyField = t.data.get('contactKeyField').get('SObjectFieldName');
        query = 'SELECT '+selectClause+' FROM '+sObjectName+' WHERE '+contactKeyField+' = :cList AND IsPrimary__c = True';
        
        return query;
    }
    
    public class OcdlaContactsException extends Exception {}
/*
 * 
 * URL: https://developer.salesforce.com/forums/?id=906F00000008ycfIAA
You can't go from Contacts to User. You'll need to query the User object and then write some code to determine if a Contact is a portal user.  For e.g.

 		data.previousProductName = s.OrderApi__Item__r.Name;
		// data.previousOrderId = s.OrderApi__Item__r.Name;
		data.previousOrderLineId = s.OrderApi__Sales_Order_Line__c;
		data.previousProductPurchaseDate = s.OrderApi__Sales_Order_Line__r.OcdlaOrderDate__c;

List<Contact> listOfContacts = however you're getting your list of Contacts;

List<User> portalUsers = [select contactId from User where contactId in (select id from Contact where id in :listOfContacts)];

 

Set<Id> contactIds = new Set<Id> ();

for (User  u : portalUsers)

{

   contactIds.add(u.contactId);

}

 

for (Contact c : listOfContacts)

{

 if (contactIds.contains(c.Id);

{

//You know if that this Contact has a Portal User. Perform any neccessary business logic here

}

}  
    
*/
    
}