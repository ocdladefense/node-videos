public without sharing class ClickpdxPricebookEntryManager {

    private static Map<Id,PricebookEntry> PricebookEntries = new Map<Id,PricebookEntry>();
    
    private static Map<Id,PricebookEntry> PricebookEntriesByProduct = new Map<Id,PricebookEntry>();

    private static Map<Id,Decimal> prices = new Map<Id,Decimal>();
    
    private static String[] fields = new String[]{
        'Id',
        'Product2Id',
        'UnitPrice',
        'Discounts__c',
        'Product2.Name',
        'Product2.IsActive',
        'Product2.GrantValue__c',
        'Product2.HasRequiredForms__c',
        'Product2.Forms__c',
        'Product2.ProrationType__c',
		'Product2.ClickpdxCatalog__LineDescription__c',
        'Product2.ClickpdxCatalog__IsMembersOnly__c',
        'Product2.OcdlaMembershipStatusGrant__c',
        'Product2.OcdlaMinimumBarYearEligibility__c',
        'Product2.Event__c',
        'Product2.Event__r.Early_Bird_End_Date__c'
    };
    
    public ClickpdxPricebookEntryManager(){
        
    }
        
    public ClickpdxPricebookEntryManager(Product2 prod){
        this(new List<Product2>{prod});
    }
    
    public  ClickpdxPricebookEntryManager(List<Product2> prods){
        loadPricebookEntries(prods);
    }

    public ClickpdxPricebookEntryManager(Id pricebookEntry){
        this(new List<Id>{pricebookEntry});
    }
    
    public ClickpdxPricebookEntryManager(List<Id> pricebookEntries){
        loadPricebookEntries(pricebookEntries);
    }
    
    public ClickpdxPricebookEntryManager(List<PricebookEntry> entries){
		Set<Id> theIds = (new Map<Id,PricebookEntry>(entries)).keySet();
        List<Id> listIds = new List<Id>();
        listIds.addAll(theIds);
        loadPricebookEntries(listIds);
    }
 

        
    public PricebookEntry entry(Id pricebookEntryId){
        if(null == pricebookEntryId){
            throw new ClickpdxPricebookEntryException('PricebookEntry Id cannot be null.');
        }
        if(null == PricebookEntries.get(pricebookEntryId)){
            loadPricebookEntries(new List<Id>{pricebookEntryId});                        
        }
        return PricebookEntries.get(pricebookEntryId);
    }
    
    public PricebookEntry productEntry(Id product2Id){
        if(null == PricebookEntriesByProduct.get(product2Id)){
            loadPricebookEntries(new List<Product2>{new Product2(Id=product2Id)});                        
        }
        return PricebookEntriesByProduct.get(product2Id);
    }
    


    public static Decimal getPrice(Id pricebookEntryId){
        ClickpdxPricebookEntryManager manager = new ClickpdxPricebookEntryManager();
        
        PricebookEntry entry;
        Decimal salePrice;
        
        
		entry = manager.entry(pricebookEntryId);
        if(null != prices.get(pricebookEntryId)){
            return prices.get(pricebookEntryId);
        }
        
        // Any relevant Early Bird dates for this Product/Ticket.
        Date earlyBird;
        
        Decimal discountPrice;
        
        
        if(null != entry.Product2.Event__c){
            earlyBird = [SELECT Id, Early_Bird_End_Date__c FROM Event__c WHERE Id = :entry.Product2.Event__c].Early_Bird_End_Date__c;
        }


        ClickpdxPriceRule discount = null == entry.Discounts__c ? null : (ClickpdxPriceRule)JSON.deserialize(entry.Discounts__c, ClickpdxPriceRule.class);

        if(null != discount && null != earlyBird && 'Early Bird' == discount.name && System.today() <= earlyBird){
            discountPrice = discount.price;
        } else if( null != discount && discount.name == 'Member Price' && null != discount.price && ClickpdxCustomer.isCustomerCurrentMember()){
            discountPrice = discount.price;
        }
        
        salePrice = null == discountPrice ? entry.UnitPrice : discountPrice;
        prices.put(pricebookEntryId,salePrice);
        return salePrice;
    }
    
        
    public static void loadPricebookEntries(List<Id> pricebookEntryIds){
        if(alreadyLoaded(pricebookEntryIds)) return;
		String query = String.join(fields,',');
        List<PricebookEntry> entries = Database.query('SELECT '+query+' FROM PricebookEntry WHERE Id = :pricebookEntryIds');
        Map<Id,PricebookEntry> additional;
        
        additional = (null != entries && entries.size()>0) ? new Map<Id,PricebookEntry>(entries) : new Map<Id,PricebookEntry>();
		PricebookEntries.putAll(additional);
        setProductPricebookEntries();
    }
    
    private static Boolean alreadyLoaded(List<Id> pricebookEntryIds){
        for(Id entryId : pricebookEntryIds){
            if(!PricebookEntries.containsKey(entryId)) return False;
        }
        return True;
    }
    
    public static void loadPricebookEntries(List<Product2> products){
        Map<Id,Product2> theProducts = new Map<Id,Product2>(products);
        
        Set<Id> product2Ids = theProducts.keySet();
        
		String query = String.join(fields,',');
        Id pricebook2Id = Test.isRunningTest() ? Test.getStandardPricebookId() : OrgOcdla.getStdPricebookId();
		List<PricebookEntry> entries = Database.query('SELECT '+query+' FROM PricebookEntry WHERE Product2Id = :product2Ids AND Pricebook2Id = :pricebook2Id AND IsActive = True');
        Map<Id,PricebookEntry> additional;
        
        additional = (null != entries && entries.size()>0) ? new Map<Id,PricebookEntry>(entries) : new Map<Id,PricebookEntry>();
        PricebookEntries.putAll(additional);
        setProductPricebookEntries();
    }
    
    private static void setProductPricebookEntries(){
        for(PricebookEntry entry :PricebookEntries.values()){
            PricebookEntriesByProduct.put(entry.Product2.Id, entry);
        }
    }
 
    public class ClickpdxPricebookEntryException extends Exception {}
    
}