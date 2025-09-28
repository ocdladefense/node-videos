public class EntityConfiguration {
    
    
    private Map<String,Object> config;
    
    
    
    public Object getConfig() {
        EntityConfiguration__mdt entity = [SELECT Config__c FROM EntityConfiguration__mdt WHERE DeveloperName = 'CommunityConfig' LIMIT 1];
        
        Map<String,Object> config = (Map<String,Object>)JSON.deserializeUntyped(entity.Config__c);
        
        return config;
    }
    
    
    public EntityConfiguration(String name) {
        if(null == name) throw new EntityConfigurationException('ENTITY_ID_ERROR: The referenced id cannot be empty.');
        
        EntityConfiguration__mdt entity = [SELECT Config__c FROM EntityConfiguration__mdt WHERE DeveloperName = :name LIMIT 1];
        
        config = (Map<String,Object>)JSON.deserializeUntyped(entity.Config__c);
    }
    
    
    
    public Object get(String key) {
        return this.config.get(key);
    }
    
    
    public void put(String key, Object value) {
        this.config.put(key, value);
    }
    

    // Convert the Map back to a JSON string.
    public String toJson() {
        return JSON.serializePretty(this.config, True);
    }
    
    
    private class EntityConfigurationException extends Exception {}
    
}