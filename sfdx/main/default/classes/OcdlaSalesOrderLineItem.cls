public without sharing class OcdlaSalesOrderLineItem {
    private static Integer count = 0;
    
    private Id lineId {get;set;}
    
    public String lineNo {get;set;}
    
    public String price {get;set;}
    
    public String description {get;set;}
    
    public String forName {get;set;}
    
    public String itemPassword {get;set;}
    
    public String subtotal {get;set;}
    
    public String qty {get;set;}
    
    public String downloadFileName {get;set;}
    
    // public String downloadLink {get;set;}
    
    public OrderApi__Item__c relatedItem {get;set;}
    
    public OrderApi__Item__c relatedParent {get;set;}
    
    public Boolean isDownloadable {get;set;}
    
    public OcdlaSalesOrderLineItem(OrderApi__Sales_Order_Line__c item){
        lineId = item.Id;
        forName = '';
            
        relatedItem = [SELECT Id,Ocdla_Is_Option__c,OrderApi__Is_Downloadable__c,
                       OrderApi__Download_File_Location__c,OrderApi__Download_File_Name__c,
                       OrderApi__Download_File_Type__c,Ocdla_Item_Password__c,Ocdla_Catalog_Parent_Item__c
                       FROM OrderApi__Item__c WHERE Id = :item.OrderApi__Item__c];
        
        if(relatedItem.Ocdla_Is_Option__c && relatedItem.Ocdla_Catalog_Parent_Item__c!=null){
            relatedParent = [SELECT Id,OrderApi__Is_Downloadable__c,OrderApi__Download_File_Location__c,
                             OrderApi__Download_File_Name__c, OrderApi__Download_File_Type__c
                             FROM OrderApi__Item__c WHERE Id = :relatedItem.Ocdla_Catalog_Parent_Item__c];
        }
        isDownloadable = relatedItem.OrderApi__Is_Downloadable__c;
        price = '$'+item.OrderApi__Sale_Price__c;
        description = item.OrderApi__Line_Description__c;
        qty = ''+Math.Round(item.OrderApi__Quantity__c);
        subtotal = '$'+item.OrderApi__Subtotal__c;
        itemPassword = relatedItem.Ocdla_Item_Password__c;
        String linkyLink = this.getDownloadLink();
        // OcdlaSalesOrderLineItem.count = OcdlaSalesOrderLineItem.count+1;
        // lineNo = OcdlaSalesOrderLineItem.count+'';
    }
    
    public String getDownloadLink(){
        String link;
        if(isDownloadable){
            link = '<a href="'+this.getDownloadFileLocation()+'">'+this.getDownloadFileName()+'</a>';
        } else {
            link = '';
        }
        link += '<!-- More information on this link can be found using the Id for this OrderApi__Sales_Order_Line__c object'+
            ' (Id: '+lineId+')-->';
        return link;
    }
    
    private String getDownloadFileName(){
        if(relatedItem.OrderApi__Download_File_Name__c!=null && relatedItem.OrderApi__Download_File_Name__c!='parent'){
            return relatedItem.OrderApi__Download_File_Name__c;
        }
        else if(relatedParent.OrderApi__Download_File_Name__c!=null){
			return relatedParent.OrderApi__Download_File_Name__c;
        }
        else return 'No valid Filename';
    }
    
    private String getDownloadFileLocation(){
        if(relatedItem.OrderApi__Download_File_Location__c!=null && relatedItem.OrderApi__Download_File_Location__c!='parent'){
            return relatedItem.OrderApi__Download_File_Location__c;
        }
        else if(relatedParent.OrderApi__Download_File_Location__c!=null){
			return relatedParent.OrderApi__Download_File_Location__c;
        }
        else return '';
    }

}