public class AwsSnsUnsubscribeConfirmation {

    private String theMessage;
    
    
    public AwsSnsUnsubscribeConfirmation(String theMessage) {
        this.theMessage = theMessage;
    }    

    
    public List<AwsSns__c> getRecords() {
        
        return new List<AwsSns__c>{new AwsSns__c(Message__c = theMessage)};
    }
}