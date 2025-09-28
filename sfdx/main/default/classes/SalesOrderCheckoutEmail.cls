public without sharing class SalesOrderCheckoutEmail {
    public List<OrderApi__Sales_Order_Line__c> lines {get;set;}
    
    public OrderApi__Sales_Order__c so {get;set;}
    
    public String soTotal {
        get {
            OrderApi__Sales_Order__c tmp = [SELECT Id,OrderApi__Total__c FROM OrderApi__Sales_Order__c WHERE Id=:this.so.Id LIMIT 1];
            return '$'+tmp.OrderApi__Total__c;
        }
        set;
    }
    
    public SalesOrderCheckoutEmail(){
        // soTotal = '$100.00';
    } 
    
    /*
* public static Map<String,String> getFormattedLineItem(OrderApi__Sales_Order_Line__c item) {
Map<String,String> a = new Map<String,String>{};
a.put('OrderApi__Sale_Price__c','$'+Math.round(item.OrderApi__Sale_Price__c));
return a;
}
*/
    public List<OcdlaSalesOrderLineItem> getFormattedLineItems(){
        // so.
        List<OcdlaSalesOrderLineItem> theItems = new List<OcdlaSalesOrderLineItem>();
        List<OrderApi__Sales_Order_Line__c> theLineItems = [SELECT Id, Name,
                                                            OrderApi__Contact__r.FirstName,
                                                            OrderApi__Contact__r.LastName,
                                                            OrderApi__Item__c,
                                                            OrderApi__Line_Description__c,
                                                            OrderApi__Sale_Price__c,OrderApi__Quantity__c,
                                                            OrderApi__Subtotal__c,
                                                            (SELECT EventApi__Attendee__r.EventApi__Full_Name__c
                                                             FROM EventApi__Registration_Items__r)
                                                            FROM OrderApi__Sales_Order_Line__c
                                                            WHERE OrderApi__Sales_Order__c=:so.Id];
        Integer counter = 0;
        for (OrderApi__Sales_Order_Line__c item : theLineItems) {
            if(null != item.EventApi__Registration_Items__r && item.EventApi__Registration_Items__r.size() > 0){
                for(EventApi__Registration_Item__c r : item.EventApi__Registration_Items__r){
                    counter++;
                    OcdlaSalesOrderLineItem theItem = new OcdlaSalesOrderLineItem(item);
                    theItem.lineNo = counter+''; 
                    theItem.forName = r.EventApi__Attendee__r.EventApi__Full_Name__c;
					theItem.qty = '1';
                    theItem.subtotal = '$'+(item.OrderApi__Subtotal__c/item.EventApi__Registration_Items__r.size());
                    theItems.add(theItem);
                }
            }
            else {
                counter++;
                OcdlaSalesOrderLineItem theItem = new OcdlaSalesOrderLineItem(item);
                theItem.lineNo = counter+'';  
                theItem.forName = item.OrderApi__Contact__r.FirstName + ' '+ item.OrderApi__Contact__r.LastName;
                theItems.add(theItem);
            }
        } 
        return theItems;
    }
}