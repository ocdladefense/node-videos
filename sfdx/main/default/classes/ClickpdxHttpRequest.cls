public class ClickpdxHttpRequest implements HttpCalloutMock{
    
    static String TEST_SERVER = 'membertest.ocdla.org';
    
    static String PROD_SERVER = 'members.ocdla.org';
    
    private String endpoint;
      
    private HttpRequest req;
    
    public String domain {get;set;}
    
    // @future(callout=true)
    public static void executeUsernameChange(String contactId, String oldUsername, String newUsername){
        /*
        // Our Http callout to reset an OCDLA username.
        ClickpdxHttpRequest req;
        
        // The response from the callout.
        HTTPResponse resp;
        
        // Setup some example username info.
        Map<String,String> usernameUpdate = new Map<String,String>();
        
        // The endpoint for the reset
        String url;
        
        String usernameResetUrl;
        
        usernameResetUrl = 'username-update';
        
        url =  usernameResetUrl + '/'+ contactId;
        
        // Okay, here's the old username (not sure if we need it)
        // and the new username.
        usernameUpdate.put('oldUsername',oldUsername);
        usernameUpdate.put('newUsername',newUsername);
        
        req = new ClickpdxHttpRequest(url);
        
        
        req.setPostBody(usernameUpdate);
        
        resp = req.send();
        */
    }
    
    public ClickpdxHttpRequest(String url){
        Organization org;
        
        req = new HttpRequest(); 
        
        Ocdla_Apps__c ocdlaSettings;
        
        org = [SELECT Id, InstanceName, IsSandbox FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        
        ocdlaSettings = Ocdla_Apps__c.getValues(UserInfo.getUserId());
        
        domain = org.IsSandbox ?  TEST_SERVER : PROD_SERVER;
        
        this.endpoint = url;
    }
    
    public static String parseData(String data){
        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(data);
        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){ 
                //&&  (parser.getText() == 'totalPrice')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                System.debug(parser.getText());
            }
        }
        return data;
    }
    
    public static String formatPostBody(String fieldName,String fieldValue){
        return fieldName+'='+EncodingUtil.urlEncode(fieldValue, 'UTF-8');
    }
    
    public static String formatPostBody(Map<String,String> vals){
        List<String> postBody = new List<String>();
        for(String fieldName: vals.keySet()){
            if(''==fieldName) continue;
            postBody.add(fieldName+'='+EncodingUtil.urlEncode(vals.get(fieldName), 'UTF-8'));
        }
        return String.join(postBody,'&');                 
    }
    
    public void setPostBody(Map<String,String> vals){
        String body;
        
        body = ClickpdxHttpRequest.formatPostBody(vals);
        //Set the HTTPRequest body	
        req.setBody(body); 	
    }
    
    public HTTPResponse send() {
        
        Http http;
        
        HttpCalloutMock mock = null;
        
        HTTPResponse resp;
        
        // Create a map to be converted to JSON
        // Map<String,String> response = new Map<String,String>();
        
        
        //Set HTTPRequest Method
        req.setMethod('POST');
        
        //Set HTTPRequest header properties
        // req.setHeader('content-type', 'text/json');
        // req.setHeader('Content-Length','1024');
        req.setHeader('Host',domain);
        // req.setHeader('Connection','keep-alive');
        req.setEndpoint( 'https://'+domain+'/'+endpoint);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');   
        // req.setHeader('Date',getDateString()); 
                System.debug('XX SERVER:'+domain);
        
        
        http = new Http();
        
        
        
        //Execute web service call here	
        if (Test.isRunningTest()){// (mock!=null)) {
            return this.respond(req);
        } else {
            resp = http.send(req);
        }	
        
        System.debug('STATUS:'+resp.getStatus());
        System.debug('STATUS_CODE:'+resp.getStatusCode());
        
        
        System.debug(resp.getBody());
        
        return resp;
    }
    
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('GREAT SCOTT');
        return res;
    }
}