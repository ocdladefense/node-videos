public class StoreSearch
{
    public List<SObject> products {public get;private set;}
    
    public string JsonProducts{public get;private set;}
    
    
    
    public StoreSearch()
    {
        //string is whatever is coming from the force page 
        products = [SELECT Name, Description from Product2];// Where name Like %'searchKey'%
        
        JsonProducts = JSON.Serialize(products);  
    }
    
    @RemoteAction
    public static Map<string, List<SObject>>GetQueryResults(string[] searchTerms)
    { 
        String searchKey; 
        
        searchKey = String.join(searchTerms,' ');
        
        /** Previous query **/
        // String searchQuery='select Name,id,description, from product2 where name like \'%'+searchKey+'%\' Limit 100';
        
        
        String searchQuery = 'SELECT Product2.Id, Product2.Event__c, Product2.Name, Product2.Description, UnitPrice, Discounts__c FROM PricebookEntry '+
            'WHERE IsActive = True AND (Product2.Name LIKE \'%'+searchKey+'%\' OR Product2.Description LIKE \'%'+searchKey+'%\') '+
            'ORDER BY Product2.Name LIMIT 100 OFFSET 0';
        
        List<SObject> products = Database.query(searchQuery);
        
        return new Map<string, List<SObject>>{'Product2' => products};
    }
}