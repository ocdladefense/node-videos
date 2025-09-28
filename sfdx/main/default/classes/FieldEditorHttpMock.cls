@isTest
public class FieldEditorHttpMock implements HttpCalloutMock {
    


    public FieldEditorHttpMock() {}


    // This would be a mock response to a PUT method.
    public HttpResponse respond(HttpRequest req) {
       
        

        HttpResponse resp = new HttpResponse();
        // resp.setBody(mock.getBody());
        resp.setStatusCode(200);
        resp.setStatus('Apex generated Mock HttpResponse.');
 
        // System.debug('The mock response status code is ' + codeForDebug);
        return resp;
    }
    
}