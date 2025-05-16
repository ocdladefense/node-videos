public without sharing class VideoApp extends CommunityController {
    
    
    public String subjectId {get; private set;}
    
    public SObject subject {get;private set;}
    
    private String cid;

    public Boolean hasAccess = False;
    
    public Boolean isStaff = True;

    private Id mediaId;
    
    public String resourceId {get; private set;}
    
      
    public VideoApp() {
        Map<String,String> params = ApexPages.currentPage().getParameters();
        
		User u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
       
        this.cid = u.ContactId;
        this.mediaId = params.get('id'); // Actual Id of the Media__c record.
        List<Media__c> medias = [SELECT Id, Name, Event__c, Event__r.Name, ResourceId__c FROM Media__c WHERE Id=:this.mediaId];
        
        if(null != medias && medias.size() > 0) {
        	Media__c theMedia = medias[0];
        	this.resourceId = theMedia.ResourceId__c;
        	this.subjectId = theMedia.Event__c;
        }
        
        this.isStaff = null != params.get('isStaff') && params.get('isStaff') == 'True' ? True : False;
    }

    
    
    /**
     * Retrieve video and other assets for a given subject.
     * 
     * A subject represents an abstraction of any pool of resources.
     *
	 */ 
    @RemoteAction
    public static MediaAsset[] getAssets(String subjectId) {

        String subjectHandler = 'EventSubject';
        String allHandler = 'AllSubject';
        
        String handler = null == subjectId || '' == subjectId.trim() ? allHandler : subjectHandler;
        
        System.type t = Type.forName(handler);
        ISubject subject = (ISubject) t.newInstance();
        subject.setSubjectId(subjectId);
        
        
		Map<Id,MediaAsset> assets = fromRecords(subject.getItems());
        
        return assets.values();
    }
    
    
    
    public List<SelectOption> getSubjects() {

        List<SelectOption> theOptions = new List<SelectOption>();
        
        SelectOption theDefault = new SelectOption('','-- All Media --',False);
        SelectOption space = new SelectOption('','',True);
        SelectOption eventSubject = new SelectOption('',' -- BY SEMINAR -- ',True);
        
        theOptions.add(theDefault);
        theOptions.add(space);
        theOptions.add(eventSubject);
        
        List<SObject> theEvents = Database.query('SELECT Id, Name, IsMediaEnabled__c FROM Event__c '+
                                                 ' WHERE IsMediaEnabled__c = True ORDER BY Start_Date__c DESC');
        
        for(SObject evt : theEvents) {
        	String value = evt.Id;
            String label = (String)evt.get('Name');
            theOptions.add(new SelectOption(value,label,!(Boolean)evt.get('IsMediaEnabled__c')));
        }
        
        
        return theOptions;
    }



         
    public static Map<Id,MediaAsset> fromRecords(List<SObject> records){
        Map<Id,MediaAsset> assets = new Map<Id,MediaAsset>();
        
        for(SObject record :records){
            MediaAsset asset = new MediaAsset(record);
            assets.put(record.Id, asset);
        }
        
        return assets;
    }
    
    

    

    @RemoteAction
    public static Boolean getHasAccess(String resourceId) {

        Boolean hasAdminRights;
        
        Boolean hasPurchasedProductRights;
        
        Boolean hasAttendeeRights;
        
		User u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        
        Map<String,Object> params = new Map<String,Object>{'resourceId' => resourceId, 'contactId' => u.ContactId};
            

    
        if(null == resourceId) {
            throw new VideoAppException('MISSING_RESOURCE_ID');
        }
        
        hasAdminRights = AdminPermission.hasPermission(null);
  
        hasPurchasedProductRights = PurchasedProductPermission.hasPermission(params);
        
        hasAttendeeRights = AttendeePermission.hasPermission(params);
        
        return hasAdminRights || hasAttendeeRights || hasPurchasedProductRights;
    }

    
}