public without sharing class MultiFieldSet {


	private static final String DEFAULT_SOBJECT_NAME = 'Contact';
    
    /**
     *One fieldSet
	*/
    public String theFieldSets {get; set;}
    

    
    public String[] hiddenFields = new String[]{};
    
    
    /**
     * The record that will be used for optional binding
     *  and expression evaluation.
     */
    public SObject record {get; set;}
    
    
    
    public Id recordId {get; set;}
    

    
    public MultiFieldSet() {}

    public MultiFieldSet(String fieldSets) {
        this.theFieldSets = fieldSets;         
    }

    public MultiFieldSet(String fieldSets, String recordId) {
        this.theFieldSets = fieldSets; 
        this.recordId = recordId;
    }

    
    public void addHiddenField(String apiName) {
        this.hiddenFields.add(apiName);
    }
	
    
    public String buildQuery() {
        
        String[] fieldSets = this.theFieldSets.split(',');
        
        if(null == recordId && null != this.record) {
            recordId = this.record.Id;
        }
        
        if(null == fieldSets) {
            throw new FieldSetException('INIT_ERROR: MultiFieldSet instance was not assigned a fieldSets array.');
        }

        SObjectType recordType = null == recordId ? ((SObject) Type.forName(DEFAULT_SOBJECT_NAME).newInstance())
                                  .getSObjectType() : recordId.getSObjectType();
        String SObjectName = null == recordType ? 'Contact' : String.valueOf(recordType);
        

 
            
        Map<String,String> fields = new Map<String,String>();
        Set<String> uniqueFields;
        
        for(String fsName : fieldSets) {
            FieldSet fs = new FieldSet(fsName, recordType);
            for(String field : fs.getFieldNames()) {
                fields.put(field,null);
            }
        }
        
        for(String apiName : hiddenFields) {
            fields.put(apiName,null);
        }
        
        uniqueFields = fields.keySet();
        

        
        return this.buildQuery(new List<String>(uniqueFields), SObjectName, recordId);
    }

    
    
    
    
    public String buildQuery(String[] fields, String fromClause, Id recordId) {

        
		String query = 'SELECT Id, ' + String.join(fields, ', ') + ' FROM ' + fromClause;
        query += null == recordId ? '' : ' WHERE Id =\'' + recordId + '\'';
        
        return query;
    }
    
    
    /**
     * Render the FieldSets.
     * 
     * First we need to query for all of the fields specified in the 
     *   FieldSet.
     */
    public Component.Apex.PageBlock getBuildFieldSets() {

        String[] fieldSets = this.theFieldSets.split(',');
        
        if(null == recordId) {
            recordId = this.record.Id;
        }
        
        if(null == fieldSets) {
            throw new FieldSetException('INIT_ERROR: MultiFieldSet instance was not assigned a fieldSets array.');
        }
        
        
		Component.Apex.PageBlock block = new Component.Apex.PageBlock();
        
        
        Boolean debug = True;
        
        
        SObjectType recordType = recordId.getSObjectType();
        String SObjectName = String.valueOf(recordType);
        
        FieldSet[] fieldSetHelpers = new FieldSet[]{};

        
        for(String fsName : fieldSets) {
            FieldSet fs = new FieldSet(fsName, recordType);
            fieldSetHelpers.add(fs);
        }



		// record = Database.query(query);

        
        for(FieldSet fs: fieldSetHelpers) {
            FieldSetForm section = new FieldSetForm(fs, this.record);
            block.childComponents.add(section.getFields());
        }

        
        return block;
    }
 
    
    
    
    private class FieldSetException extends Exception {}
}