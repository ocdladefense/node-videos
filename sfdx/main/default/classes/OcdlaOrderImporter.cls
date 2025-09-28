public class OcdlaOrderImporter {

    Map<Id,OrderApi__Sales_Order__c> legacySalesOrders;
    
	List<OrderApi__Sales_Order_Line__c> legacySalesOrderLines;
    
    List<Order> newOrders;
    
    List<OrderItem> newOrderItems;
    
    public static final Boolean TEST_RUN = True;
    
    private static final String ORDER_ITEM_IMPORT_DESCRIPTION = 'Imported BON Purchase.';
    
    public OcdlaOrderImporter(){
        List<Id> salesOrderIds = new List<Id>();
        // Run the query
        // Save the orders
        legacySalesOrders = new Map<Id,OrderApi__Sales_Order__c>();
        legacySalesOrderLines = getEligibleSalesOrderLines();
        newOrders = new List<Order>();
        newOrderItems = new List<OrderItem>();
        
        // Loop through the Sales Order Lines and construct a List of related Sales Order Ids
        for(OrderApi__Sales_Order_Line__c line :legacySalesOrderLines){
			salesOrderIds.add(line.OrderApi__Sales_Order__c);
        }
        
        
        legacySalesOrders.putAll(loadLegacySalesOrders(salesOrderIds));
    }

    
    
    public void saveOrders(){
        // Construct new Orders.
        for(OrderApi__Sales_Order__c so :legacySalesOrders.values()){
            Order o = createOrderFromSalesOrder(so);
            newOrders.add(o);
        }
        
        upsert newOrders;
    }

    public void saveOrderItems(){
      	PricebookEntry entry = [SELECT Id FROM PricebookEntry WHERE Product2.Name = 'Books Online Subscription' LIMIT 1];
        saveOrderItems(entry.Id);
    }
    
    public void saveOrderItems(Id pricebookEntryId){
        // Construct a Map of Orders where the key is the legacy Sales Order Id.
        Map<Id,Order> theOrders = new Map<Id,Order>();
        
        List<Order> theList = [SELECT Id, OrderApi_Sales_Order__c FROM Order WHERE Status = 'Draft Imported'];
        for(Order o :theList){
			theOrders.put(o.OrderApi_Sales_Order__c,o);
        }
        
        
        // Construct new OrderItems for the above.
        for(OrderApi__Sales_Order_Line__c line: legacySalesOrderLines){
			OrderItem li = new OrderItem();
            Order thisOrder = theOrders.get(line.OrderApi__Sales_Order__c);
            
            li.OrderId = thisOrder.Id;
            li.UnitPrice = line.OrderApi__Sale_Price__c;
            li.Quantity = 1.0;
            li.Description = ORDER_ITEM_IMPORT_DESCRIPTION;
            li.Contact__c = line.OrderApi__Contact__c;
            li.PricebookEntryId = pricebookEntryId;
            // Set Pricebook Entry
            
            newOrderItems.add(li);
        }
        
        upsert newOrderItems;
    }
    
    
    
    public void deleteImportedOrders(){
        List<Order> forDelete;
        
        forDelete = [SELECT Id FROM Order WHERE Status = 'Draft Imported'];
        
        delete forDelete;
    }
    
    public void deleteImportedOrderItems(){
        
        List<OrderItem> forDelete;
        
        forDelete = [SELECT Id FROM OrderItem WHERE Description = :ORDER_ITEM_IMPORT_DESCRIPTION];
        
        delete forDelete;
    }
    
    private Map<Id,OrderApi__Sales_Order__c> loadLegacySalesOrders(List<Id> theSalesOrderIds){
        Map<Id,OrderApi__Sales_Order__c> theSalesOrders;
        
        theSalesOrders = new Map<Id,OrderApi__Sales_Order__c>([SELECT Id, OrderApi__Account__c, OrderApi__Contact__c, OrderApi__Posted_Date__c,
                                                              Ocdla_Order_Origin__c, OrderApi__Status__c FROM OrderApi__Sales_Order__c
                                                              WHERE Id = :theSalesOrderIds]);
        return theSalesOrders;
    }
    
    private List<OrderApi__Sales_Order_Line__c> getEligibleSalesOrderLines(){
        List<OrderApi__Sales_Order_Line__c> lines = new List<OrderApi__Sales_Order_Line__c>();
        Set<Id> ItemIds = getTargetItemIds();
        
        lines.addAll([SELECT Id, OrderApi__Sale_Price__c, OrderApi__Sales_Order__c, OrderApi__Item__c, OrderApi__Contact__c
                      FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__c = :ItemIds AND OrderApi__Is_Posted__c = True]);
        
        return lines;
    }
    
    
    private Set<Id> getTargetItemIds(){
        Map<Id,OrderApi__Item__c> items;
        
        items = new Map<Id,OrderApi__Item__c>([SELECT Id FROM OrderApi__Item__c WHERE Name LIKE '%Books Online%']);
        
        return items.keySet();
    }
    

    
    
    public Order createOrderFromSalesOrder(OrderApi__Sales_Order__c legacy){
        //@todo BillingAddress info? ShippingAddress info?
        Order o = new Order();
        
        o.OrderApi_Sales_Order__c = legacy.Id;
        o.Pricebook2Id = ClickpdxCore.Application.config.getStdPricebookId();
        o.Description = 'This record was created as part of a automated scripting process.';
        o.AccountId = legacy.OrderApi__Account__c;
        o.BillToContactId = legacy.OrderApi__Contact__c;
        o.EffectiveDate = legacy.OrderApi__Posted_Date__c;
        o.Origin__c = getNewOrderOrigin(legacy.Ocdla_Order_Origin__c);
        // o.Status = getNewOrderStatus(legacy.OrderApi__Status__c); // e.g., "Open","Closed","Cancelled"
        o.Status = 'Draft Imported';
        
        return o;
    }
    
    
    
    /**
     * Method should return a string corresponding to the picklist value that best
     * reflects the Order Origin in the new Order system.
     */
    private String getNewOrderOrigin(String legacyOrderOrigin){
        Map<String,String> newOrigins = new Map<String,String>();
        newOrigins.put('AMS Web Order','Web Order');
        newOrigins.put('Admin Order','Admin Order');
        newOrigins.put('Legacy Web Order','Web Order');
        newOrigins.put('Test Order','Test Order');
        
        return newOrigins.get(legacyOrderOrigin);
    }
    
    private String getNewOrderStatus(String legacyOrderStatus){
        Map<String,String> newStatuses = new Map<String,String>();
        newStatuses.put('Open','Inactive');
        newStatuses.put('Closed','Posted');
        
        return newStatuses.get(legacyOrderStatus);
    }
    
}