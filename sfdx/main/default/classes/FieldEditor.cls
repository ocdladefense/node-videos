public with sharing virtual class FieldEditor {

  
    
	public Id sobjectId;
    
    public SObject record {get; set;}
    
    public String fieldName {public get; private set;}
    
    public String fieldValue;
    
    public String codeServer {public get; private set;}
    
    
    
    public FieldEditor() {
        
        Map<String,String> query = ApexPages.currentPage()?.getParameters();

		Id sobjectId;
        String fieldName;

        if(query.get('id') != null) {
        	sobjectId = (Id)query.get('id');
        }
        
        if(query.get('fieldName') != null) {
        	fieldName = query.get('fieldName');
        }
        
        this.fieldValue = '';
        if(null != fieldName) init(fieldName,sobjectId);
    }
    

    
    
    public void init(String fieldName, Id sobjectId) {
        Map<String,String> query = ApexPages.currentPage()?.getParameters();
        
        Ocdla_Apps__c config = Ocdla_Apps__c.getOrgDefaults();
        Boolean isSandbox = [SELECT IsSandbox, Id FROM Organization].IsSandbox;
        
        this.codeServer = isSandbox ? config.Ocdla_Test_Application_Server__c : config.Ocdla_Production_Application_Server__c;
        
        for(String key : new Set<String>{'id','fieldName'}) {
            if(null == query.get(key)) {
                throw new FieldEditorException('REQUIRED_PARAMETER_MISSING: '+key+' parameter cannot be empty.');
            }
        }
        
        this.fieldName = fieldName;
        this.sobjectId = sobjectId;
        
        // Construct a query for the given field dynamically.
        Schema.SObjectType token = this.sobjectId.getSObjectType();
		Schema.DescribeSObjectResult result = token.getDescribe();
        
        String queryFormat = 'SELECT {0} FROM {1} WHERE Id = \'\'{2}\'\'';
        List<String> params = new List<String>{fieldName, result.getName(), sobjectId};

		this.record = Database.query(String.format(queryFormat,params));
        this.fieldValue = (String)record.get(fieldName);
    }
    
    
    
    public virtual void setFieldValue(String fieldValue) {
        this.fieldValue = fieldValue;
    }
    
    
    public virtual String getFieldValue() {
        return this.fieldValue;
    }

  
    
    /**
     * Save the result of the rich text edit session.
     * Results are saved to fieldName and fieldValue using the SObject.put() method.
     * We redirect with the same PageReference variables.
     */
    public virtual PageReference doSubmit() {
        
        System.debug(this.fieldValue);
		PageReference current = ApexPages.currentPage();
        Map<String,String> params = current.getParameters();
        params.put('id', this.sobjectId);
        params.put('fieldName', this.fieldName);
        // current.setRedirect(True);
        
        this.record.put(this.fieldName, this.fieldValue);
        update this.record;
        
        return current;
    }
    
    
    public virtual PageReference doCancel() {
        
        String theUrl = '/'+String.valueOf(this.sobjectId);
        
        return new PageReference(theUrl);
    }
}