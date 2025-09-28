public class AwsSnsNotification {
    
    
    @testVisible
    private String msg;
    
    @testVisible
    private String source;
    
    @testVisible
    private String bounceType;
    
    @testVisible
    private String bounceSubType;
    
    @testVisible
    private List<Object> bouncedRecipients;
    
    
    
    
    public AwsSnsNotification(String theMessage) {

        // Message.notificationType
        Map<String,Object> msg = (Map<String,Object>)JSON.deserializeUntyped(theMessage);
        
        String notificationType = (String)msg.get('notificationType');
        
        // Message.bounce
        // Message.bounce.bounceType
        // Message.bounce.bounceSubType
        // Message.bounce.bouncedRecipients
        Map<String,Object> theBounce = (Map<String,Object>)msg.get('bounce');
        Map<String,Object> theMail = (Map<String,Object>)msg.get('mail');
        
        // Bounce info
        this.bounceType = (String)theBounce.get('bounceType');
        this.bounceSubType = (String)theBounce.get('bounceSubType');
        this.bouncedRecipients = (List<Object>)theBounce.get('bouncedRecipients');
        
        // Mail info
        this.source = ((String)theMail.get('source')).split('[\\-\\@]')[0];
        
        this.msg = JSON.serializePretty(msg);
    }
    
    
    public List<AwsSns__c> getRecords() {
        
        List<AwsSns__c> bounces = new List<AwsSns__c>();
        
        
        for(Object obj : bouncedRecipients) {
            Map<String,Object> recipient = (Map<String,Object>)obj;
            
            String theEmail = (String)recipient.get('emailAddress');
            
            AwsSns__c rec = new AwsSns__c();
            rec.Email__c = theEmail;
            rec.FailureType__c = bounceType;
            rec.FailureSubtype__c = bounceSubType;
            rec.Message__c = this.msg;
            rec.Source__c = this.source;
            
            bounces.add(rec);
        }
        
        return bounces;
    }
    
}