global class CatalogProductList {
    
    
    webservice String query;
    
    webservice String countQuery;
    
    webservice List<CatalogProduct> items;
    
    webservice String catalogName;
    
    
    public CatalogProductList(String catalogName){
        Id catalogId;
        List<Id> childCatalogs;
        List<OrderApi__Catalog__c> theCatalogs;
        
        this.catalogName = catalogName;
        this.items = new List<CatalogProduct>();
        childCatalogs = new List<Id>();
        
        // Lookup the catalog id based on the passed catalogName.

        
        theCatalogs = [SELECT Id, Name FROM OrderApi__Catalog__c WHERE Name = :catalogName LIMIT 1];
        
        if(!Test.isRunningTest() && 0 == theCatalogs.size()){
            throw new CatalogException('No catalogs found by that name.');
        } else if(!Test.isRunningTest()) {
            childCatalogs.add(theCatalogs[0].Id);
        
            this.items.addAll(this.buildProductList(childCatalogs));
        
            this.items.sort();
        }
    }
    
    public CatalogProductList(Id catalogId){

        this.items = new List<CatalogProduct>();
        List<Id> childCatalogs = new List<Id>();
        
        childCatalogs.add(catalogId);
        countQuery = 'SELECT COUNT() FROM Catalog_Item__c WHERE Catalog__c = :catalogName ';
                //  +' AND ClickpdxCatalog__IsOption__c = False';
                //  
                //  
        // collect any child catalog Ids

        this.items.addAll(this.buildProductList(childCatalogs));
    }
    
    private List<CatalogProduct> buildProductList(List<Id> catalogIds){
        List<CatalogProduct> tmpList = new List<CatalogProduct>();
        
        for(OrderApi__Catalog__c cat : [SELECT Id FROM OrderApi__Catalog__c WHERE OrderApi__Catalog__c = :catalogIds]){
            catalogIds.add(cat.Id);
        }
        
       query = 'SELECT Id, Name, ClickpdxCatalog__DisplayName__c,(SELECT Id, UnitPrice, Discounts__c FROM PricebookEntries) '+
           ' FROM Product2 WHERE Id IN(SELECT Product__c FROM OrderApi__Catalog_Item__c WHERE '+
           ' OrderApi__Catalog__c = :catalogIds AND OrderApi__Is_Published__c = True) ORDER BY '+
           ' ClickpdxCatalog__DisplayOrder__c NULLS LAST, ClickpdxCatalog__DisplayName__c';

        Map<Id,OrderApi__Catalog_Item__c> productCatalogItems = new Map<Id,OrderApi__Catalog_Item__c>();
        
        List<OrderApi__Catalog_Item__c> catalogItems;
        
        catalogItems = [SELECT OrderApi__Catalog__c, OrderApi__Catalog__r.Name, OrderApi__Catalog__r.OrderToken__c, Product__c FROM OrderApi__Catalog_Item__c WHERE
           OrderApi__Catalog__c = :catalogIds AND OrderApi__Is_Published__c = True];
        
        for(OrderApi__Catalog_Item__c catItem :catalogItems){
            productCatalogItems.put(catItem.Product__c,catItem);
        }
            
        for(Product2 prod :Database.query(query)){
            CatalogProduct catProduct;
            
            catProduct = new CatalogProduct(prod);
            catProduct.setCatalog(productCatalogItems.get(prod.Id));
            tmpList.add(catProduct);
        }
        
        return tmpList;
    }
    

    public void findAll(){
        query = 'SELECT Id, Name, ClickpdxCatalog__DisplayName__c, (SELECT Id, UnitPrice, Discounts__c FROM PricebookEntries) FROM Product2 '
                  +' ORDER BY ClickpdxCatalog__DisplayOrder__c NULLS LAST, ClickpdxCatalog__DisplayName__c';
        
        for(Product2 prod :Database.query(query)){
            items.add(new CatalogProduct(prod));
        }
    }
    
    private Integer getRecordCount(){
        return Database.countQuery(this.countQuery);
    }
}