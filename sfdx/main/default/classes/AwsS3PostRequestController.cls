public without sharing class AwsS3PostRequestController {

    private String responseBody;
    
   
    
    
    public String getResponseBody() {
        return this.responseBody;
    }
    
    
    
    public AwsS3PostRequestController() {
        Map<String,String> params = ApexPages.currentPage().getParameters();
        Map<String,String> body = new Map<String,String>();
        
       	String filename = params.get('file');
		Blob blobData = EncodingUtil.base64Decode(params.get('data')); 
        String mimeType = params.get('mimeType');

        try {
        	this.doSubmit(blobData, filename, mimeType);
	        body.put('link', 'https://ocdla-salesforce.s3.us-west-2.amazonaws.com/'+ filename);
        } catch(Exception e) {
    		body.put('error', e.getMessage());        
        }
        this.responseBody = JSON.serialize(body);
    }
    
    
    
    public void doSubmit(Blob blobData, String filename, String fileMime) {

        HttpRequest httpReq = new HttpRequest();
		httpReq.setEndpoint('https://l15zyo5h4a.execute-api.us-west-2.amazonaws.com/v1/ocdla-salesforce/'+filename);
     	httpReq.setMethod('PUT');
        httpReq.setBodyAsBlob(blobData);
        httpReq.setHeader('Content-Type',fileMime);
        
        Http client = new Http();
        
        client.send(httpReq);
    }
    
    
}