public without sharing class ClickpdxCheckoutEmailLineItemSummary {
     
     
    public List<ClickpdxOrderLineItem> lineItems {get;set;}
    
    private static Map<Id,Product2> parentProducts;
    
    private static Order staticOrder;
    
    private static Contact billToContact;
    
    public Order o {get;set {
        o = value;
        staticOrder = value;
        if(o == null || o.BillToContactId == null) return;
        billToContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :o.BillToContactId];
    }}
    
    public String soTotal {
        get {
            Decimal total = (o == null || o.TotalAmount == null) ? 0 : o.TotalAmount;
            return '$'+total;
        }
        set;
    }
  
    
    // Default constructor.
    public ClickpdxCheckoutEmailLineItemSummary(){} 
    
    
    public List<ClickpdxOrderLineItem> getFormattedLineItems(){
        List<OrderItem> theLineItems = new List<OrderItem>();
        List<Id> parentProductIds = new List<Id>();
        Integer counter = 0;
		lineItems = new List<ClickpdxOrderLineItem>();
		

        theLineItems.addAll([SELECT Id, Product2Id, Quantity, UnitPrice, TotalPrice, Note_1__c, Note_2__c, Note_3__c, Description, PricebookEntry.Product2.Name,
                        PricebookEntry.Product2.ClickpdxCatalog__LineDescription__c, PricebookEntry.Product2.ClickpdxCatalog__ParentProduct__c,
                        PricebookEntry.Product2.ClickpdxCatalog__IsDownloadable__c,
                        PricebookEntry.Product2.ClickpdxCatalog__DownloadFileName__c,PricebookEntry.Product2.ClickpdxCatalog__DownloadUrl__c,
                        PricebookEntry.Product2.OCDLA_Item_Password__c, Contact__c, FirstName__c, LastName__c,
                                       Contact__r.FirstName, Contact__r.LastName, Contact__r.Email
                        FROM OrderItem WHERE OrderId=:o.Id
                     ORDER BY ParentLineId__c, PricebookEntry.Product2.Name, Contact__r.LastName, Contact__r.FirstName, OrderItemNumber]);
        
        
        for(OrderItem item :theLineItems){
            if(null != item.PricebookEntry.Product2 && null != item.PricebookEntry.Product2.ClickpdxCatalog__ParentProduct__c){
                parentProductIds.add(item.PricebookEntry.Product2.ClickpdxCatalog__ParentProduct__c);
            }
        }
        
        parentProducts = null != parentProductIds && parentProductIds.size() > 0 ? getParentProducts(parentProductIds) : new Map<Id,Product2>();
        
        
        for (OrderItem item : theLineItems) {
            counter++;
            ClickpdxOrderLineItem theItem = new ClickpdxOrderLineItem(item);
            theItem.parentProduct2Id = item.PricebookEntry.Product2.ClickpdxCatalog__ParentProduct__c;
            theItem.parentProduct2 = null == theItem.parentProduct2Id ? null : parentProducts.get(theItem.parentProduct2Id);
            theItem.downloadFileName = item.PricebookEntry.Product2.ClickpdxCatalog__DownloadFileName__c;
            theItem.downloadLocation = item.PricebookEntry.Product2.ClickpdxCatalog__DownloadUrl__c;
            theItem.downloadPassword = item.PricebookEntry.Product2.Ocdla_Item_Password__c;
            theItem.isDownloadable = item.PricebookEntry.Product2.ClickpdxCatalog__IsDownloadable__c;
            theItem.downloadLink = theItem.getDownloadLink();
            theItem.forName = theItem.getForName(item.FirstName__c, item.LastName__c, item.Contact__r.FirstName, item.Contact__r.LastName);
            theItem.price = '$'+item.UnitPrice;
            theItem.note1 = item.Note_1__c;
            theItem.note2 = item.Note_2__c;
            theItem.note3 = item.Note_3__c;
            if(item.Description != null && item.Description.trim() != ''){
                theItem.description = item.Description;
            } else {
                theItem.description = item.PricebookEntry.Product2.ClickpdxCatalog__LineDescription__c;
            }
            theItem.qty = ''+Math.Round(item.Quantity);
            theItem.subtotal = '$'+item.TotalPrice;
            theItem.lineNo = counter+'';  
            lineItems.add(theItem);
        }  
        
        
        return lineItems;
    }
    

    @TestVisible
    private Map<Id,Product2> getParentProducts(List<Id> parentIds){
		List<Product2> parentProductList;
        Map<Id,Product2> returnMap = new Map<Id,Product2>();
        
        parentProductList = [SELECT Id, ClickpdxCatalog__IsDownloadable__c, ClickpdxCatalog__DownloadFileName__c, ClickpdxCatalog__DownloadFileType__c,
                             ClickpdxCatalog__DownloadUrl__c, Ocdla_Item_Password__c FROM Product2 WHERE Id = :parentIds];
         
        returnMap.putAll(parentProductList);
        
        return returnMap;
    }
    
    public class ClickpdxOrderLineItem {
        private Integer count = 0;
        
        private SObject item;
        
        public Id lineId {get;set;}
        
        public Id parentLineId {get; set;}
        
        public Id parentProduct2Id {get; set;}
        
        public Product2 parentProduct2 {get; set;}
        
        public Id contactId {get;private set;}
        
        public Contact relatedContact {get; set;}
        
        public String lineNo {get;set;}
        
        public String note1 {get;set;}
        public String note2 {get;set;}
        public String note3 {get;set;}
        
        public String price {get;set;}
        
        public String description {get;set;}
        
        public String forName {get;set;}
        
        public String itemPassword {get;set;}
        
        public String subtotal {get;set;}
        
        public String qty {get;set;}
        
        public String downloadFileName {get;set;}
        
        public String downloadPassword {get;set;}
        
        public String downloadLocation {get;set;}
        
        public String downloadLink {get;set;}
        
        public Boolean isDownloadable {get;set;}
        
        public ClickpdxOrderLineItem(SObject item){
            Product2 prod;
            Contact c;
            this.item = item;
            lineId = (Id)item.Id;
        }
     
    
        private String getForName(String assignedFirstName, String assignedLastName, String autoFirstName, String autoLastName){
            Contact orderContact = billToContact;
            String forName;
            
            
            if(null != assignedFirstName){
                forName = assignedFirstName + ' '+assignedLastName;
            } else if(null != autoLastName) {
                forName = autoFirstName + ' '+autoLastName;
            } else {
                forName = orderContact.FirstName + '' + orderContact.LastName;
            }
			
            return forName;
        }
        
        
        

        public String getDownloadLink(){
            String link = '';
            
            if(isDownloadable){
                link = '<a href="'+this.getDownloadFileLocation()+'">'+this.getDownloadFileName()+'</a>';
            }
            link += '<!-- More information on this link can be found using the Id for this OrderItem record'+
                ' (Id: '+lineId+')-->';
            return link;
        }
        
        private String getDownloadFileName(){
            
            if(downloadFileName != 'parent'){
                return downloadFileName;
            }
            else {
                return this.parentProduct2.ClickpdxCatalog__DownloadFileName__c;
            }
        }
        
        private String getDownloadFileLocation(){

            if(downloadFileName != 'parent'){
                return downloadLocation;
            }
            else {
                return this.parentProduct2.ClickpdxCatalog__DownloadUrl__c;
            }
        }

    }
    


}