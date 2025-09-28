public class CsvProductLookup {

    static Map<String,List<PricebookEntry>> entries = new Map<String,List<PricebookEntry>>();
    
    
    public static PricebookEntry lookup(String qbCode) {
        
        // QBCode__c
        Id priceBook2Id = CsvUtils.getStdPricebookId();
        List<PricebookEntry> found;
        
        if(null != entries.get(qbCode)) {
            found = entries.get(qbCode);
        }
        else {
            found = [SELECT Id, Name, Product2.Name, Product2.ClickpdxCatalog__Format__c, Product2.ClickpdxCatalog__MemberPrice__c, Product2.ClickpdxCatalog__StandardPrice__c FROM PricebookEntry WHERE Pricebook2Id = :priceBook2Id AND Product2.QBCode__c = :qbCode];
			entries.put(qbCode,found);            
        }
        
        if(0 == found.size()) {
            throw new LookupNotFoundException('No lookup record found. (Product, '+qbCode+')');
        }
        
        else if(1 < found.size()) {
            return getHardCopyOption(found);
          	// throw new LookupException('Multiple lookup records found. (Product, '+qbCode+')');
        }
        
        else return found[0];
    }
    
    
    public static PricebookEntry getHardCopyOption(List<PricebookEntry> entries) {
        
        for(PricebookEntry entry: entries) {
            if(entry.Product2.ClickpdxCatalog__Format__c == 'Hard Copy') return entry;
        }
        
        return entries[0];
    }
}