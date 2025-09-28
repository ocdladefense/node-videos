public class FieldSet {


	public String fsName {get; set;}
    
    public SObjectType recordType {get; set;}



    public FieldSet() {}
    
    public FieldSet(String fsName, SObjectType recordType){
        this.fsName = fsName;
        this.recordType = recordType;
    }
    



    
    
    
    public String[] getFieldNames() {
        
        return getFieldNames(this.fsName, String.valueOf(this.recordType));
    }
    
    public static String[] getFieldNames(String fieldSetName, String SObjectName) {

        // Get the object type
		SobjectType objectType = Schema.getGlobalDescribe().get(SObjectName);
 
        // Get the field set members from the targeted field set for the object.
        List<Schema.FieldSetMember> fieldSetMembers = new List<Schema.FieldSetMember>();
        

        fieldSetMembers.addAll(objectType.getDescribe().fieldSets.getMap().get(fieldSetName).getFields());
        
        
        List<String> apiNames = new List<String>();
        
        for(Schema.FieldSetMember fsm : fieldSetMembers) {
            String apiName = fsm.getFieldPath();
            if(!apiNames.contains(apiName)){
                apiNames.add(apiName);
            }
        }
        


		return apiNames;
    }

    


    
}