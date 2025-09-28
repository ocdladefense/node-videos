// https://ocdla--ocdpartial.sandbox.my.site.com/services/apexrest/api/media/access/id
@RestResource(urlMapping='/api/media/access/*')
global without sharing class MediaAccess {
    
      
    
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse resp = Restcontext.response;
        
        Map<String,String> headers = req.headers;
        String body = req.requestBody.toString();
        
        
          
        // String messageType = headers.get('x-amz-sns-message-type');
        String resourceId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        // Map<String,String> details = (Map<String,String>)JSON.deserialize(body, Map<String,String>.class);
        
        resp.statusCode = 200;

           
       
     
    }
    
}