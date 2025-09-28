public class CsvContactLookup {

    
    public static Contact lookup(String name) {
        
        String[] parts = name.trim().split(' ',2);
        
        List<Contact> found = [SELECT Id, AccountId, FirstName, LastName, Email, Ocdla_Current_Member_Flag__c FROM Contact WHERE FirstName=:parts[0] AND LastName=:parts[1]];
        
        if(0 == found.size()) {
            throw new LookupNotFoundException('No lookup record found. ('+parts[0]+' '+parts[1]+')');
        }
        
        else if(1 < found.size()) {
          	throw new LookupException('Multiple lookup records found.('+parts[0]+' '+parts[1]+')');
        }
        
        else return found[0];
    }
}