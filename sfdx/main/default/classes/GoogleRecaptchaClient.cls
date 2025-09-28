public class GoogleRecaptchaClient {

    
	private static final String GOOGLE_RECAPTCHA_URL = 'https://www.google.com/recaptcha/api/siteverify';
    
    
    
    public Decimal getScore(String token) { 
        HttpResponse resp = send(token);
        System.debug(resp.getBody());
        String body = resp.getBody();
        System.debug(body);
        Object desir = JSON.deserializeUntyped(body);
        Map<String,Object> ebt = (Map<String,Object>)desir;
        
        return null != ebt.get('score') ? (Decimal)ebt.get('score') : 0.0;
    }
    

    
    
    
    public static HttpResponse send(String token) {

        Map<String,String> params = new Map<String,String>();
        params.put('secret', System.Label.RecaptchaSecret);
        params.put('response',token);
            
        // Create a map to be converted to JSON
        // Map<String,String> response = new Map<String,String>();
        HttpRequest req = new HttpRequest(); 
        
        //Set HTTPRequest Method
        req.setMethod('POST');
        // req.setTimeout(CALLOUT_TIMEOUT);
        
        // Set HTTPRequest header properties
        // req.setHeader('Content-Type', 'application/json');
        // req.setHeader('Content-Length','1024');
        // req.setHeader('Host','ocdla--ocdpartial.sandbox.my.site.com');
        // req.setHeader('Connection','keep-alive');
        req.setEndpoint(GOOGLE_RECAPTCHA_URL);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');   
        // req.setHeader('Date',getDateString()); 
        
        		

        // Set the HTTPRequest body	
        // String body = JSON.serialize(params);
        String body = formatRequestBody(params);
        req.setBody(body); 	
        
        Http http = new Http();
        
        // Execute web service call here		
        return http.send(req);	
    }
    
    
    public static String formatRequestBody(Map<String,String> ccVals){
        List<String> postBody = new List<String>();
        
        for(String key: ccVals.keySet()) {
            if('' == key) continue;
            if(null == ccVals.get(key)) continue;
            postBody.add(key+'='+EncodingUtil.urlEncode(ccVals.get(key), 'UTF-8'));
        }

        return String.join(postBody,'&');                 
    }
    
    
    

    
}