public class ProfileController extends CommunityController {

    
    
    public SObject record {get; set;}
    
    
    public String[] fieldSets {get; set;}
    
     
    Id exampleRecordId = '003j000000rU9NvAAK';
    
    public Id getCurrentContactId() {
        
        User u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        
        return u.ContactId;
    }
    
    
    
    public ProfileController() {
		Id recordId = getCurrentContactId();
        if(null == recordId) {
            recordId = exampleRecordId;
        }
        
        
        fieldSets = new List<String>{'Contact_Information_Basic'};
        //fieldSets2 = new List<String>{'Expert_Witness_Profile'};


        SObjectType recordType = recordId.getSObjectType();
        String SObjectName = String.valueOf(recordType);
        

        FieldSet fs = new FieldSet('Contact_Information_Basic', recordType);
        FieldSet fs2 = new FieldSet('Expert_Witness_Profile', recordType);
        String[] fields = fs.getFieldNames();
        fields.addAll(fs2.getFieldNames());
        
        String query = this.buildQuery(fields, SObjectName, recordId);
 
        
        record = Database.query(query) == null || Database.query(query).isEmpty() ? recordType.newSObject() : Database.query(query);
    }
    
    
    public String buildQuery(String[] fields, String fromClause, Id recordId) {

        
		return 'SELECT Id, ' + String.join(fields, ', ') + ' FROM ' + fromClause + ' WHERE Id =\'' + recordId + '\'';
    }
    
    
    

    public SObject save(){
        
        upsert this.record;
        return this.record;
    }
    
    
    public PageReference saveRecord() {
        
        Map<String,Object> fM = this.record.getPopulatedFieldsAsMap();
        
        if(this.record == null || !fm.isEmpty()){
            this.save();
        }
        
        return null;
    }
}