@isTest
private class AwsSnsTest {
    
        
    
	private static String example = '{  "Type": "Notification",  "MessageId": "41aab4af-f5c5-5a64-89c1-eb430bd94469",  "TopicArn": "arn:aws:sns:us-west-2:735936240395:SESMail",' +
        ' "Message": "{\\"notificationType\\":\\"Bounce\\",\\"bounce\\":{\\"feedbackId\\":\\"010101941927d5a9-cbc83629-632d-4315-8d72-4234776224e2-000000\\",\\"bounceType\\":\\"Permanent\\",\\"bounceSubType\\":\\"OnAccountSuppressionList\\",' +
        ' \\"bouncedRecipients\\":[{\\"emailAddress\\":\\"dan@lawfirmnw.com\\",\\"action\\":\\"failed\\",\\"status\\":\\"5.1.1\\",' +
        ' \\"diagnosticCode\\":\\"Amazon SES did not send the message to this address because it is on the suppression list for your account. For more information about removing addresses from the suppression list, see the Amazon SES Developer Guide at ' +
        ' https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email-suppression-list.html\\"}],\\"timestamp\\":\\"2024-12-30T20:00:28.000Z\\",\\"reportingMTA\\":\\"dns; amazonses.com\\"},\\"mail\\":{\\"timestamp\\":\\"2024-12-30T20:00:28.052Z\\",' +
        ' \\"source\\":\\"ocdlapond-bounces@list.ocdla.org\\",\\"sourceArn\\":\\"arn:aws:ses:us-west-2:735936240395:identity/list.ocdla.org\\",\\"sourceIp\\":\\"35.162.222.119\\",\\"callerIdentity\\":\\"ses-smtp-user.20230202-184954\\",\\"sendingAccountId\\":\\"735936240395\\",' + 
        '  \\"messageId\\":\\"010101941927d394-89d24f40-c604-4d68-98f8-3127d17710fa-000000\\",\\"destination\\":[\\"dan@lawfirmnw.com\\",\\"mark@levinemchenry.com\\",\\"mark@mlanglaw.com\\",\\"aeason@mpdlaw.com\\",\\"mganow-jones@mpdlaw.com\\"]}}",  "Timestamp": "2024-12-30T20:00:28.794Z",' +
        ' "SignatureVersion": "1",  "Signature": "ijLL8M/tq2Xxt16XAIrEbSDrpdbpOCBZhcvhz3E460/3TgGenIz+NFABf9L2Ze2KGYgeIDWS5cP6P9oq2ePQNOMsqVCi3QjvXno4rNN5R0pH4u4tItZ5KH3JWA6eGVoLCbjTIj76g7ZaEpwepf2/VMikksR0sBXsE7xs7RL4nDxX8c5pKLV/b2dd07jvbHhbU6ez+LV54bAbq4k0Y2YJ6HdfO3UTBdzhyElxMDdH0Zr0wOeVDowM1RJiOVvUnTSn4PNJUkyyPWBzHXPWZ6C61CJQ0STmrYuDuClC55Yft4zAtB+yeaNsAmCFHnQd+8xH7RW8E98yAnqHJF0cjA703w==",' +
        ' "SigningCertURL": "https://sns.us-west-2.amazonaws.com/SimpleNotificationService-9c6465fa7f48f5cacd23014631ec1136.pem",  "UnsubscribeURL": "https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:735936240395:SESMail:6b4d0a77-7dbd-4911-b8b9-bce4bace910b"}';
    
        
    @isTest
    private static void testNotification(){
        
        
        Blob snsBody = Blob.valueOf(example);
        Map<String,String> headers = new Map<String,String>();
        
        RestRequest req = new RestRequest();
        req.requestUri ='/services/apexrest/api/aws/sns/ses';
        req.httpMethod = 'POST';
        req.requestBody = snsBody;
        req.headers.put('x-amz-sns-message-type','Notification');
        
        RestContext.request = req;  
        
        AwsSns.doPost();
        
        // System.assert(strId !=null );
    }
    
    @isTest
    private static void testSubscriptionConfirmation() {
        
        Blob snsBody = Blob.valueOf(example);
        Map<String,String> headers = new Map<String,String>();
        
        RestRequest req = new RestRequest();
        req.requestUri ='/services/apexrest/api/aws/sns/ses';
        req.httpMethod = 'POST';
        req.requestBody = snsBody;
        req.headers.put('x-amz-sns-message-type','SubscriptionConfirmation');
        
        RestContext.request = req;
        
        AwsSns.doPost();
    }
    
    
    @isTest
    private static void testUnsubscribeConfirmation() {
        
        Blob snsBody = Blob.valueOf(example);
        Map<String,String> headers = new Map<String,String>();
        
        RestRequest req = new RestRequest();
        req.requestUri ='/services/apexrest/api/aws/sns/ses';
        req.httpMethod = 'POST';
        req.requestBody = snsBody;
        req.headers.put('x-amz-sns-message-type','UnsubscribeConfirmation');
        
        RestContext.request = req;
        
        AwsSns.doPost();
    }
    
}