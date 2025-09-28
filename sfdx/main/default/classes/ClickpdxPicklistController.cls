public class ClickpdxPicklistController {
    private String systemObject;
    public String getSystemObject() {
        return systemObject;
    }
    
    public void setSystemObject(String value) {
        systemObject = value;
    }
    
    private String picklist_Field;
    
    public String getPicklist_Field() {
        return picklist_Field;
    }
    
    public void setPicklist_Field(String value) {
        picklist_Field = value;
    }
    
    public String listDefaultValue  { get; set; }
    public String listDefaultLabel  { get; set; }
    public Boolean haveDefaultValue { get; set; }
    
    public List<SelectOption> picklistOptions {get;set;}
    
    public static List<SelectOption> getStateCodes(){
        return new List<SelectOption>{
          new SelectOption('OR','Oregon'),
          new SelectOption('WA', 'Washington'),
          new SelectOPtion('CA', 'California')
        };
    }
    
    public List<SelectOption> getItems() {
        if('MailingStateCode' == picklist_Field) return getStateCodes();
        
        
        List<Schema.PicklistEntry> entries_local;
        if (systemObject != null) {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            Set<String> objectKeys = gd.keySet();
            for(String objectKey: objectKeys) {
                if (objectKey == systemObject.toLowerCase()) {
                    Schema.SObjectType systemObjectType = gd.get(objectKey);
                    Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
                    Map<String, Schema.SObjectField> M = r.fields.getMap();
                    Set<String> fieldNames = M.keySet();
                    if (picklist_Field == null) {
                        break;
                    }
                    
                    for(String fieldName: fieldNames) {
                        if (fieldName == picklist_Field.toLowerCase()) {
                            Schema.SObjectField field = M.get(fieldName);
                            Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                            entries_local = fieldDesc.getPicklistValues();
                            break;
                        }
                    }
                }
            }
        }
        
        List<SelectOption> options = new List<SelectOption>();
        if (haveDefaultValue == true) {
            if (listDefaultValue == null)
                listDefaultValue = '';
            if (listDefaultLabel == null)
                listDefaultLabel = '--None--';
            options.add(new SelectOption(listDefaultValue,listDefaultLabel));
        }
        
        if (entries_local != null) {
            for(Schema.PicklistEntry picklistItem : entries_local) {
                options.add(new SelectOption(picklistItem.getValue(),picklistItem.getLabel()));
            }
        }
        return options;
    }
}