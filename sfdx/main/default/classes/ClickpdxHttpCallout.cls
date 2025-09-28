public virtual class ClickpdxHttpCallout {
    
    Map<String,String> params;
    
    public HttpResponse res {get;private set;}
    
    public String response {get;private set;}
    
    public String httpJsonResponse {get;protected set;}
    
	public static final Integer CALLOUT_TIMEOUT = 60000;
    
    public String getResponse(){
        return this.response;
    }
    
    
    public ClickpdxHttpCallout(String className){
        this(className, new Map<String,String>());
    }
    
    public ClickpdxHttpCallout(IClickpdxHttpSendable obj, Map<String,String> reqParams){
        this.params = reqParams;
        
        Map<String,String> pCopy = this.params.clone();
        

                obj.setParams(pCopy);
                this.res = this.send(obj);
                // System.debug('STATUS:'+res.getStatus());
				// System.debug('STATUS_CODE:'+res.getStatusCode());
                this.response = obj.formatResponse(this.res);
        
    }
    
    public ClickpdxHttpCallout(String className, Map<String,String> reqParams){
        this.params = reqParams;
        
        Map<String,String> pCopy = this.params.clone();
        

            //String[] classes = new String[]{};
                
                //Clickpdx_Apps__c cs = Clickpdx_Apps__c.getOrgDefaults();
            
            //classes = null != cs.Clickpdx_Scheduled_Classes__c ? cs.Clickpdx_Scheduled_Classes__c.split(',') : classes;
            //classes = Test.isRunningTest() ? new String[]{'OcdlaBonNotification'} : classes;
        try {
            // for(String className :classes){
            Type targettype = Type.forName(className);
            if(targettype != null)
            {
                IClickpdxHttpSendable obj = (IClickpdxHttpSendable)targettype.NewInstance();
                obj.setParams(pCopy);
                this.res = this.send(obj);
                // System.debug('STATUS:'+res.getStatus());
				// System.debug('STATUS_CODE:'+res.getStatusCode());
                this.response = obj.formatResponse(this.res);
            }
            else {
                throw new ClickpdxHttpCalloutException('The class, '+className+', could not be located.');
            }
        } catch(Exception e){
            String message = e.getTypeName() + ' at line ' + e.getLineNumber() + ': '+ e.getMessage();
			this.res = createHttpErrorResponse(503, message, e.getStackTraceString());
            this.response = this.res.getBody();
        }
            
        //} catch(Exception e){
        //    Map<String,String> errors = new Map<String,String>();
        //    errors.put('error',e.getMessage());
        //    this.response = JSON.serialize(errors);
        //} 
}
    
    
    
    public ClickpdxHttpCallout(){
        if(ApexPages.CurrentPage().getParameters().get('httpDelegate') != null){
	        this(ApexPages.CurrentPage().getParameters().remove('httpDelegate'),ApexPages.CurrentPage().getParameters());
        } else {
            this(new DefaultSendable(),ApexPages.CurrentPage().getParameters());
        }
    }
    
    

    public HttpResponse createHttpErrorResponse(Integer errorCode, String message){
        return createHttpErrorResponse(errorCode, message, null);
    }
    
    public HttpResponse createHttpErrorResponse(Integer errorCode, String message, String stacktrace){
        HttpResponse res = new HttpResponse();
        Map<String,String> body = new Map<String,String>();
        body.put('error',message);
        body.put('stackTrace',stacktrace);
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(body));
        res.setStatusCode(errorCode);
        return res;
    }
    
    protected virtual HttpResponse send(IClickpdxHttpSendable interf){

        
        // Create a map to be converted to JSON
        // Map<String,String> response = new Map<String,String>();
        HttpRequest req = new HttpRequest(); 
        
        //Set HTTPRequest Method
        req.setMethod('POST');
        req.setTimeout(CALLOUT_TIMEOUT);
        
        //Set HTTPRequest header properties
        // req.setHeader('content-type', 'text/json');
        // req.setHeader('Content-Length','1024');
        req.setHeader('Host',interf.getDomain());
        // req.setHeader('Connection','keep-alive');
        req.setEndpoint( interf.getProtocol() + '://'+interf.getDomain()+'/'+interf.getEndpoint());
        req.setHeader('Content-Type','application/x-www-form-urlencoded');   
        // req.setHeader('Date',getDateString()); 
        
        

        // Set the HTTPRequest body	
        String body = ClickpdxHttpCallout.formatPostBody(interf.getParams());
        req.setBody(body); 	
        
        Http http = new Http();
        
        HttpResponse res;
        
        // Execute web service call here		
        res = http.send(req);	

        
        return res;
        
        /*
} catch(System.CalloutException e) {
return null;//'error';//JSON.serialize(response);
}
catch(Exception e){
return null;//'error';//JSON.serialize(response);
}
*/
    }
  
/*
    public static String parseJson(String resp){
        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(resp);
        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){ 
                //&&  (parser.getText() == 'totalPrice')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                System.debug(parser.getText());
            }
        }
        return resp;
    }
*/
    
    public static String formatPostBody(String fieldName,String fieldValue){
        return fieldName+'='+EncodingUtil.urlEncode(fieldValue, 'UTF-8');
    }
    
    public static String formatPostBody(Map<String,String> ccVals){
        List<String> postBody = new List<String>();
        for(String fieldName: ccVals.keySet()){
            if(''==fieldName) continue;
            postBody.add(fieldName+'='+EncodingUtil.urlEncode(ccVals.get(fieldName), 'UTF-8'));
        }

        return String.join(postBody,'&');                 
    }
    
    class DefaultSendable implements IClickpdxHttpSendable {
        public final String protocol = 'https';
        
        public String domain;
        
        public final String endpoint = 'ccAuthorize';
        
        public Map<String,String> params {get;private set;}
        
        public String getProtocol(){
            return this.protocol;
        }
        
        public String getDomain(){
            return 'cs3.salesforce.com';
        }
        
        public String getEndpoint(){
            return this.endpoint;
        }
        
        public Map<String,String> getParams(){
            return this.params;
        }
    
        public Map<String,String> setParams(Map<String,String> params){
            this.params = params;
            return this.params;
        }
    
        public String formatResponse(HttpResponse resp){
            return resp.getBody();
        }
    }
    
    public class ClickpdxHttpCalloutException extends Exception{
        
    }
}