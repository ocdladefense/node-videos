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
        
        
        
        //how do we know which customer is submitting this request.
        // Get that customers Id
         Id userId = userInfo.getUserId();    //'005VC00000ET8LaYAL'
        
        // Query the ContactId from the User record
        User currentUser = [
            SELECT Id, ContactId
            FROM User
            WHERE Id = :userId
            LIMIT 1
        ];
        
        Id contactId = currentUser.ContactId; //'003VC00000rtzKUYAY'
        
         
        // Then determind if they are an administrator
        Map<String, Object> adminParams = new Map<String, Object>{
            'contactId' => contactId
        };

        // If the user is an admin, return 200 regardless
        if (AdminPermission.hasPermission(adminParams)) {
            resp.statusCode = 200;
            resp.addHeader('X-Access-Type', 'Admin access granted');
            return;
        }
        
        
        // 	If they have purchased a product that gives them access to a video, return that video(s)
        
        
        // Build params map to pass into PurchasedProductPermission
        Map<String, Object> params = new Map<String, Object>{
            'resourceId' => resourceId,
            'contactId'  => contactId
        };
        
        
        Boolean hasPermission = PurchasedProductPermission.hasPermission(params);
        
        // If user is a regular customer, then we check if they are an active OCDLA member
        if (hasPermission) {
            resp.statusCode = 200;
            resp.addHeader('X-Access-Type', 'Customer access granted');
            
        // If they are not active, return 403, false
        } else {
            resp.statusCode = 409;
            resp.addHeader('X-Access-Type', 'Access denied');
            
        }            
     
    }
    
}