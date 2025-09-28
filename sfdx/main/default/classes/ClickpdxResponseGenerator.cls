@isTest
global class ClickpdxResponseGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        // Create a fake response

        // Optionally, only send a mock response for a specific endpoint
        // and method.
        // System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        // System.assertEquals('GET', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        res.setStatus('Apex generated Mock HttpResponse.');
        return res;
    }
}