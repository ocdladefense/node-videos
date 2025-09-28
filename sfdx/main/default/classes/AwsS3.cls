// https://ocdla--ocdpartial.sandbox.my.site.com/services/apexrest/api/aws/s3/{filename}
@RestResource(urlMapping='/api/aws/s3/*')
global without sharing class AwsS3 {
    
      
    
    @HttpPut
    global static void doPut() {
        RestRequest req = RestContext.request;
        RestResponse resp = Restcontext.response;
        
        Map<String,String> headers = req.headers;
        String body = req.requestBody.toString();
        
        Map<String,String> mockBody = new Map<String,String>();
        mockBody.put('link', 'https://ocdla-salesforce.s3.us-west-2.amazonaws.com/bottles-2.png');
        //"link": "path/to/image.jpg" }
        
        resp.responseBody = Blob.valueOf(JSON.serialize(mockBody));
    }
}