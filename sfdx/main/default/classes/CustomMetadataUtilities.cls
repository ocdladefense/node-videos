public class CustomMetadataUtilities implements Metadata.DeployCallback {


    
	private static String LOG_PREFIX = 'CUSTOM METADATA DEPLOYMENT ID: ';

    
    
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        handleResultHelper(result.status);
    }
    
    public void handleResultHelper(Metadata.DeployStatus theStatus) {
        String message = theStatus == Metadata.DeployStatus.Succeeded ? 'Success' : 'Failure';
        System.debug(LOG_PREFIX+ message);
    }
    
    
    
    public static Metadata.DeployContainer save(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;
        
        for(String key : fieldWithValuesMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldWithValuesMap.get(key); 
            customMetadata.values.add(customField);
        }
        
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        mdContainer.addMetadata(customMetadata);
        
        
        return mdContainer;
    }
    
    
    
    public static Id deploy(Metadata.DeployContainer container) {
        
        
        Id jobId = Metadata.Operations.enqueueDeployment(container, new CustomMetadataUtilities());

        
        return jobId;
    }
}