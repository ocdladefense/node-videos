public class MenuItem {
    
    public Id catId {get;private set;}
    
    public String name {get;private set;}
    
    public String url {get;private set;}
    
    public List<MenuItem> children {get;private set;}
    
    public MenuItem(Id catId){
        this.catId = catId;
        OrderApi__Catalog__c c = [SELECT Id, Name, Url__c FROM OrderApi__Catalog__c WHERE Id = :catId];
        this.name = c.Name;
        this.url = c.Url__c;
        children = new List<MenuItem>();
    }
    
    public MenuItem(){
        this.catId = null;
        this.name = 'ROOT MENU';
        children = new List<MenuItem>();
    }
    
    public Boolean hasChildren(){
        Integer count = Database.countQuery('SELECT COUNT() FROM OrderApi__Catalog__c WHERE OrderApi__Catalog__c = :catId');
        return 0 != count;
    }
    
    public Boolean hasProducts(){
        Integer count = Database.countQuery('SELECT COUNT() FROM OrderApi__Catalog_Item__c WHERE OrderApi__Catalog__c = :catId');
        return 0 != count;
    }
    
    public List<MenuItem> getChildren(){
        List<OrderApi__Catalog__c> cTemp;
        
        cTemp = [SELECT Id, Name, Url__c FROM OrderApi__Catalog__c WHERE OrderApi__Catalog__c = :this.catId AND OrderApi__Is_Published__c  = True ORDER BY OrderApi__Display_Order__c NULLS LAST, Name];
        
        for(OrderApi__Catalog__c cat :cTemp){
            children.add(new MenuItem(cat.Id));
        }
        
        return children;
    }
}