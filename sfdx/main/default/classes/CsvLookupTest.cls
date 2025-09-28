// CsvLookupTest, CsvParserTest, CsvUploadTest
@isTest
public class CsvLookupTest {
    
    
    
    @testSetup
    private static void insertRecords() {

        Account a = new Account(Name='John Doe');
		insert a;

        
        Contact c = new Contact(AccountId=a.Id, FirstName='John', LastName='Doe', Email='test@example.com');
        insert c;
        
        Contact c2 = new Contact(AccountId=a.Id, FirstName='Jane', LastName='Doe', Email='test@example.com');
        insert c2;
        Contact c3 = new Contact(AccountId=a.Id, FirstName='Jane', LastName='Doe', Email='test@example.com');
        insert c3;
        
        Product2 prod = new Product2(Name='Milk',IsActive=True,QBCode__c='Test123ABC',ClickpdxCatalog__StandardPrice__c=100.00,ClickpdxCatalog__MemberPrice__c=80.00);
        insert prod;
        
        Product2 prod2 = new Product2(Name='Milk',IsActive=True,QBCode__c='Test123ABC_D',ClickpdxCatalog__StandardPrice__c=100.00,ClickpdxCatalog__MemberPrice__c=80.00);
        insert prod2;
        Product2 prod3 = new Product2(Name='Milk',IsActive=True,QBCode__c='Test123ABC_D',ClickpdxCatalog__StandardPrice__c=100.00,ClickpdxCatalog__MemberPrice__c=80.00);
        insert prod3;
    }
    
    
    
    @isTest
    private static void doCustomerLookup() {
        
        Contact customer;
        
        try
        {
        	customer = CsvContactLookup.lookup('John Doe');
        }
        catch(LookupNotFoundException e)
        {
			
        }
        catch(LookupException e)
        {
            
        }
        
        System.assertEquals(customer.Email, 'test@example.com');
        
        try
        {
        	customer = CsvContactLookup.lookup('Not Found');
        }
        catch(LookupNotFoundException e)
        {
			
        }
        catch(LookupException e)
        {
            
        }
        
        try
        {
        	customer = CsvContactLookup.lookup('Jane Doe');
        }
        catch(LookupNotFoundException e)
        {
			
        }
        catch(LookupException e)
        {
            
        }
    }
    
    
      
      
    @isTest
    private static void doProductLookup() {
        
        PricebookEntry entry;

        // This should pass without any thrown exceptions.
        entry = CsvProductLookup.lookup('Test123ABC');

        // Test that we can create conditions where both of these exceptions are thrown as expected.
        Boolean lookupNotFound = False;
        Boolean duplicateLookup = False;
        
        try {
            entry = CsvProductLookup.lookup('Test123ABC_Z');
        } catch(LookupNotFoundException e) {
            lookupNotFound = True;
        } catch(LookupException e) {
            duplicateLookup = True;
        }
        
        System.assert(lookupNotFound && !duplicateLookup);
        
        // Test that we can create conditions where both of these exceptions are thrown as expected.
        lookupNotFound = False;
        duplicateLookup = False;
        
        try {
            entry = CsvProductLookup.lookup('Test123ABC_D');
        } catch(LookupNotFoundException e) {
            lookupNotFound = True;
        } catch(LookupException e) {
            duplicateLookup = True;
        }

    }
    
    
    
}