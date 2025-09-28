@isTest
public class GoogleRecaptchaMockResponse implements HttpCalloutMock {

    // private GoogleRecaptcha.ResponseScore scoreType;
    
    public static GoogleRecaptcha.ResponseScore scoreType = GoogleRecaptcha.ResponseScore.HUMAN;
    
    
    
    
    
    public HttpResponse respond(HttpRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatus('OK');
        resp.setStatusCode(200);
        Map<String,Object> body = new Map<String,Object>();
        
        if(scoreType == GoogleRecaptcha.ResponseScore.BOT) {
            body.put('success',True);
            body.put('score', GoogleRecaptcha.LOW_SCORE); // simulate a bot score from Google reCAPTCHA.
        } else if(scoreType == GoogleRecaptcha.ResponseScore.HUMAN) {
            body.put('success',True);
            body.put('score',GoogleRecaptcha.HIGH_SCORE); // simulate a human response.
        } else {
            throw new MockResponseException('Scoretype is null.');
        }
        
        resp.setHeader('Content-Type','application/json');   
        resp.setBody(JSON.serialize(body));
        
        return resp;
    }
    
    private class MockResponseException extends Exception {}
}