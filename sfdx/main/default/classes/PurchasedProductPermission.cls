public without sharing class PurchasedProductPermission implements IPermission {

	public static final Integer PERMISSION_DENIED = 0;
    
    public static final Integer PERMISSION_GRANTED = 1;
    
    
      
    
    public static Boolean hasPermission(Map<String,Object> params) {
        
        Integer access = hasAccess(params);
        
       	return access == PERMISSION_GRANTED;
    }
    
    
    /**
     * return 1 = access granted
     * return 0 = access denied
     */
    public static Integer hasAccess(Map<String,Object> params) {
        
        // Who are we checking access for?
		Id contactId; 
        
        // For which resource are we checking access?
        String resourceId = (String)params.get('resourceId');
       	Media__c media;
        
        // For products related to events: what is the related event for this product.
		Id chapterId;
        
		// Optional.
        contactId = null != params.get('contactId') ? (Id)params.get('contactId') : null;
        
        

        
        try { 
            media = Database.query('SELECT Event__c, Chapter__c, IsPublic__c FROM Media__c WHERE ResourceId__c = :resourceId');
        } catch(System.QueryException e) {
            System.debug(e);
            media = null;
        }
         

        if(null == media) return PERMISSION_DENIED;
        
        if((Boolean)media.get('IsPublic__c')) return PERMISSION_GRANTED;
        

        
        
        Object tmp = media.get('Chapter__c');

        if(null == tmp) return PERMISSION_DENIED;
        
        // Confirm user has purchased a product related to this event.
        chapterId = (Id)tmp;
        
        List<SObject> purchased = Database.query('SELECT Id FROM OrderItem WHERE Contact__c = :contactId AND Product2Id IN (SELECT Id FROM Product2 WHERE Chapter__c = :chapterId)');
        
        if(null == contactId) return PERMISSION_DENIED;
        
        return null != purchased && purchased.size() > 0 ? PERMISSION_GRANTED : PERMISSION_DENIED;
    }
    
    

}