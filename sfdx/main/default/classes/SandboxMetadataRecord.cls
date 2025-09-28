public without sharing class SandboxMetadataRecord {
    
    
	private Metadata.CustomMetadata customMetadata;
        
    private String metadataType;
    
    private String developerName;
    
    
    
    public SandboxMetadataRecord(String metadataType, String developerName) {
        this.metadataType = metadataType;
        this.developerName = developerName;
		customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = metadataType+'.'+developerName; 
    }
    

    public void put(String field, String value) {
        
        Metadata.CustomMetadataValue f = new Metadata.CustomMetadataValue(); 
        f.field = field;
        f.value = value;
        this.customMetadata.values.add(f);
    }
    
    public void setMasterLabel(String label) {
		this.customMetadata.label = label;
    }
    
    public Metadata.CustomMetadata getAsMetadata() {
        
        return this.customMetadata;
    }
}