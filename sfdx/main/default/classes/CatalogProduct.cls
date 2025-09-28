global class CatalogProduct implements Comparable {
    
    webservice String displayName {get;private set;}
    
    webservice Id theId {get;private set;}
    
    webservice Decimal price {get;private set;}

    webservice String catalogName {get;private set;}
    
    webservice Decimal orderToken {get;private set;}
    
    
    

    
    public CatalogProduct(Product2 p) {
        List<PricebookEntry> entries;
        
        this.displayName = null == p.ClickpdxCatalog__DisplayName__c ? p.Name : p.ClickpdxCatalog__DisplayName__c;
        
        entries = p.getSObjects('PricebookEntries');
        
        if(null != entries && 0 < entries.size()){
            price = entries[0].UnitPrice;
        }
        theId = p.Id; 
    }
    
    
    global Integer compareTo(Object compareTo) {
        CatalogProduct compareToEmp = (CatalogProduct)compareTo;
        if (orderToken == compareToEmp.orderToken) return 0;
        if (orderToken < compareToEmp.orderToken) return 1;
        return -1;        
    }
    
    
    public void setCatalog(OrderApi__Catalog_Item__c catItem){
        catalogName = catItem.OrderApi__Catalog__r.Name;
        orderToken = catItem.OrderApi__Catalog__r.OrderToken__c;
    }
    
    
    public void setPricebookEntry(PricebookEntry entry){
        price = entry.UnitPrice;
    }
    
}