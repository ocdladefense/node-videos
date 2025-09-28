public without sharing class SandboxMetadataDeployment implements Metadata.DeployCallback {
    
    
	private List<SandboxMetadataRecord> metadataRecords = new List<SandboxMetadataRecord>();
    
    
    public SandboxMetadataDeployment() {}
    

    public void add(SandboxMetadataRecord m) {
        this.metadataRecords.add(m);
    }
    
    public String deploy() {
    
        try {
            Metadata.DeployContainer container = new Metadata.DeployContainer();
            
            for(SandboxMetadataRecord record : this.metadataRecords) {
                
               	container.addMetadata(record.getAsMetadata());
            }

            
            Id jobId = Metadata.Operations.enqueueDeployment(container, this);
            
            System.debug('JobId is: ' + jobId);

            return 'Success';
            
        } catch (Exception e) {
            return e.getMessage();
        }
    }
    

    
    // Find all sObjects available in the organization
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        String label = result.status == Metadata.DeployStatus.SUCCEEDED ? 'Success' : 'Failure';

        System.debug(label + ' ===> ' + result);  
    }
}