public class AwsSnsSubscriptionConfirmation {

    private String theMessage;
    
    
    public AwsSnsSubscriptionConfirmation(String theMessage) {
        this.theMessage = theMessage;
    }
    
    
    public List<AwsSns__c> getRecords() {
        
        return new List<AwsSns__c>{new AwsSns__c(Message__c = theMessage)};
    }
}