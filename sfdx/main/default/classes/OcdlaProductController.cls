global class OcdlaProductController extends ClickpdxStore.ProductController {

    public Product2 theProduct {get;private set;}
    
    public PricebookEntry entry {get;private set;}
    
    public Boolean isSubscribed {get;private set;}
    
    public Date expirationDate {public get; private set;}
    
    public Boolean isParent {public get; private set;}
    
    public Boolean hasChildren {public get; private set;}
    
    public List<Media__c> images {public get; private set;}
    
    public Media__c primaryImage {public get; private set;}
    
    // private List<Product2> children {public get; private set;}
    
    public List<PricebookEntry> children {public get; private set;}
    
    public List<ProductOption> options {public get; private set;}
    
    public OcdlaProductController(){
        super();
        Map<String,String> params = ApexPages.currentPage().getParameters();
        Id productId = params.get('id');
        isSubscribed = False;
        
        children = new List<PricebookEntry>();
        options = new List<ProductOption>();
        
        Id userId = UserInfo.getUserId();
		System.debug(userId);
		
		User theCustomer = [SELECT Id,Name,ContactId FROM User WHERE Id = :userId];
    
        
        
       theProduct = [SELECT Id,Name,ClickpdxCatalog__IsParent__c, ClickpdxCatalog__Image__c, ProductCode,Description,
                     ClickpdxCatalog__HtmlBlock1__c, ClickpdxCatalog__HtmlBlock2__c,
                     ClickpdxCatalog__HtmlDescription__c FROM Product2 WHERE Id = :productId];
        
        // Define a SOQL query to retrieve Product Images from the Media__c object.
        images = [SELECT ImageUrl__c FROM Media__c WHERE Product__c = :productId ORDER BY Order__c ASC];
        primaryImage = null != images && images.size() > 0 ? images[0] : null;
        
        List<PricebookEntry> entries = [SELECT Id, UnitPrice, Discounts__c, Product2.Id, Product2.Name, Product2.ProductCode,
                                        Product2.EnableQuantities__c, Product2.ClickpdxCatalog__IsMembersOnly__c, Product2.ClickpdxCatalog__OptionName__c FROM 
                     PricebookEntry WHERE Product2.Id = :params.get('id') AND IsActive = True LIMIT 1];
        entry = (null != entries && entries.size()>0) ? entries[0] : new PricebookEntry(Id=null,Product2Id=theProduct.Id);
        
        
        if(theProduct.ClickpdxCatalog__IsParent__c)        {
			children.addAll([SELECT Id, Product2.Id, Product2.EnableQuantities__c, Product2.ClickpdxCatalog__IsMembersOnly__c, Product2.ClickpdxCatalog__IsDownloadable__c,
                             Product2.ClickpdxCatalog__Format__c,Product2.Name, Product2.Description, 
                             Product2.ClickpdxCatalog__OptionName__c, UnitPrice, Discounts__c FROM PricebookEntry
                             WHERE Product2.ClickpdxCatalog__ParentProduct__c = :params.get('id') AND Product2.IsActive = True AND Product2.ClickpdxCatalog__IsOption__c = True
                            ORDER BY Product2.ClickpdxCatalog__DisplayOrder__c ASC, Product2.ClickpdxCatalog__OptionName__c ASC]);
        } else {
            options.add(new ProductOption(entry));
        }
        
        hasChildren = (children != null && children.size()>0);
        
        for(PricebookEntry e :children){
			ProductOption o = new ProductOption(e);
            options.add(o);
        }
    }
    
    static webservice Product2 getTargetUrlProduct2Id(Id sourceProduct2Id){
        Product2 source;
        Product2 target;
        
        source = [SELECT Id, Name, ClickpdxCatalog__ParentProduct__c FROM Product2 WHERE Id = :sourceProduct2Id];
        if(null != source.ClickpdxCatalog__ParentProduct__c){
            target = [SELECT Id, Name FROM Product2 WHERE Id = :source.ClickpdxCatalog__ParentProduct__c];
        }
        
        return null != target ? target : source;
    }

    public class ProductOption {
        
        public Id theId {get;private set;}
        
        public String name {get;private set;}
        
        public Boolean membersOnly {get;private set;}
        
        public Boolean enableQuantities {get; private set;}
        
        public String discounts;
        
        public ClickpdxPriceRule priceRule;
        
        public Decimal standardPrice {get;private set;}
        
        public Decimal memberPrice {get {
            if(null != priceRule){
                return priceRule.price;
            } else {
                return standardPrice;
            }
        } private set;}
        
        public ProductOption(PricebookEntry entry){
            theId = entry.Id;
            membersOnly = entry.Product2.ClickpdxCatalog__IsMembersOnly__c;
            enableQuantities = entry.Product2.EnableQuantities__c;
            name = entry.Product2.ClickpdxCatalog__OptionName__c;
            standardPrice = entry.UnitPrice;
            discounts = entry.Discounts__c;
			priceRule = discounts != null ? (ClickpdxPriceRule)JSON.deserialize(discounts, ClickpdxPriceRule.class) : null;
        }
    }
    
    

    
    public static ClickpdxPriceRule createPriceRuleObject(Decimal price, String priceRuleName){
        ClickpdxPriceRule discount;
        
        discount = new ClickpdxPriceRule();
        discount.name = priceRuleName;
        discount.price = price;
        discount.active = True;
        
        return discount;
    }
    
    
}