public class AccountManagerController extends CommunityController {

    
    
    public SObject record {get; set;}
    
    
    public String[] fieldSets {get; set;}
    

    
    public Id getCurrentContactId() {
        
        User u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        
        return null == u.ContactId && Test.isRunningTest() ? '003j000000rU9Nv' : u.ContactId;
    }
    
    
    
    public AccountManagerController() {
        
        
       	MultiFieldSet mfs = new MultiFieldSet('Contact_Information_Basic,Contact_Information,Expert_Witness_Profile', getCurrentContactId());
        mfs.addHiddenField('Ocdla_Is_Expert_Witness__c');
        mfs.addHiddenField('Ocdla_Current_Member_Flag__c');
        
        
        String query = mfs.buildQuery();
		System.debug('MULTI FIELDSET QUERY IS: '+query);
        record = Database.query(query);
    }
    
    

    public SObject save(){
        
        update this.record;
        return this.record;
    }
    
    
    public PageReference saveRecord() {
        
        this.save();
        return null;
    }
}