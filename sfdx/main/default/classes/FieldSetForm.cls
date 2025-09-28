public without sharing class FieldSetForm {

    
    public FieldSet fs {get; set;}
    
    
    
    public SObject record {get; set;} 
    
    
    
    
    
    public FieldSetForm(FieldSet fs, SObject record) {
        this.fs = fs;
        this.record = record;
    }
    
    
    public Component.Apex.PageBlockSection getFields() {
        
        String[] sampleFieldNames = fs.getFieldNames();
        
		Component.Apex.PageBlockSection block = new Component.Apex.PageBlockSection();

        for(String fieldName :sampleFieldNames) {
        	block.childComponents.add(this.getInputField(fieldName));
        }
        
        
        return block;
    }
    


    
    
    public Component.Apex.OutputLabel getOutputLabel(String apiName, String fieldLabel) {
        
        Component.Apex.OutputLabel label = new Component.Apex.OutputLabel();
        label.value = fieldLabel;
        label.for = apiName;
        
        return label;
    }  
    

    
    
    public Component.Apex.InputField getInputField(String fieldName) {
        
        // Create an input field for Account Name
        Component.Apex.InputField myField = new Component.Apex.InputField(ignoreEditPermissionForRendering = True);
        String theExpression = this.getExpression(fieldName);
        System.debug(theExpression);
        myField.expressions.value = theExpression;

        return myField;
    }
    

    
    
    private String getExpression(String fieldName) {
        
        String[] buildExpression = new String[]{
            '{!record[\'',  
            fieldName,
            '\']}'
        };
        return String.join(buildExpression, '');
    }
}