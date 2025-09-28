// https://ocdla--ocdpartial.sandbox.my.site.com/services/apexrest/api/aws/sns/ses
@RestResource(urlMapping='/api/aws/sns/*')
global without sharing class AwsSns {
    
      
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        Map<String,String> headers = req.headers;
        String body = req.requestBody.toString();
        
        
          
        String messageType = headers.get('x-amz-sns-message-type');
        String notificationSource = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Map<String,String> details = (Map<String,String>)JSON.deserialize(body, Map<String,String>.class);
        

           
        // Notification info:
        // Type - The type of notification.
        // Topic - the topic of notification.
        // Message - the actual message sent in the notification.
        String theType = (String)details.get('Type');
        String theTopicArn = (String)details.get('TopicArn');
        String theMessage = (String)details.get('Message');

        
        List<AwsSns__c> records;
        
        if(messageType == 'Notification') {
            AwsSnsNotification n = new AwsSnsNotification(theMessage);
            records = n.getRecords();
            
        } else if(messageType == 'SubscriptionConfirmation') {
            AwsSnsSubscriptionConfirmation n = new AwsSnsSubscriptionConfirmation(theMessage);
            records = n.getRecords();
            
        } else if(messageType == 'UnsubscribeConfirmation') {
            AwsSnsUnsubscribeConfirmation n = new AwsSnsUnsubscribeConfirmation(theMessage);
            records = n.getRecords();            
        }
        
        
        // Normalize records by adding the notification type and body fields.
        for(AwsSns__c record : records) {
			record.Type__c = messageType;
        }
        
        
        insert records;
    }
    
}