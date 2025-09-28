public class OcdlaCCAuthorize implements IClickpdxHttpSendable {
    
    public final String protocol = 'https';
    
    public String domain;
    
    public final String endpoint = 'ccAuthorize';
    
    public Map<String,String> params {get;private set;}
    
    // Perform any alterations to the params that will be sent to the url.
    public Map<String,String> getParams(){
        return this.params;
    }
    
    public Map<String,String> setParams(Map<String,String> passed){
        this.params = passed.clone();
        return this.params;
    }
    
    public String getProtocol(){
        return this.protocol;
    }
    
    public String getDomain(){
        Organization org = [SELECT Id, InstanceName, IsSandbox FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        
        Ocdla_Apps__c profileSettings = Ocdla_Apps__c.getValues(UserInfo.getUserId());
        Ocdla_Apps__c orgDefaults = Ocdla_Apps__c.getOrgDefaults();
        
        return org.IsSandbox ? orgDefaults.Ocdla_Test_Application_Server__c : orgDefaults.Ocdla_Production_Application_Server__c;
    }
    
    public String getEndpoint(){
        return this.endpoint;
    }
    
    public String formatResponse(HttpResponse resp){
        return resp.getBody();
    }
    
    
}