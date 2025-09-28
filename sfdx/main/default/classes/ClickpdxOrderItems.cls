global class ClickpdxOrderItems {

    
    
    public List<OrderItem> lines {public get; private set;}
    
    public String theQuery {public get;private set;}
    
    public Id eventId {get;set;}
    
    public List<Product2> ticketTypes;
    
    public Event__c e {get; private set;}
    
    Map<String,String> p = new Map<String,String>();
    
    public String retUrl {get;private set;}
    
    public String communityUrl {get;private set;}
    
    public List<SelectOption> events {get;private set;}
    
    public static final Integer PRODUCT_GRANTS_EVALUATE_ON_PARENT_LINES = 1;
    
    public static final Integer PRODUCT_GRANTS_EVALUATE_ON_LINES = 2;
    
    private static final String QUERY_FIELD_SEPARATOR = ', ';
    
    public String[] cols {get;private set;}
    
    private static final String[] DEFAULT_ATTENDEE_FIELDS = new String[]{'Id', 'OrderId', 'Contact__r.Name','Order.AccountId', 'Order.BillToContactId', 'Order.Account.Name',
        'Order.EffectiveDate','Order.OrderNumber', 'ConfirmationSentDate__c', 'Product2.Event__c', 'Description', 'UnitPrice',
        'Quantity', 'Data__c', 'FirstName__c','LastName__c', 'Contact__c', 'Contact__r.FirstName', 'Contact__r.LastName', 'Contact__r.Email',
        'OcdlaMailingStateCode__c','Note_1__c', 'Note_2__c', 'Note_3__c', 'TotalPrice', 'Product2Id', 'Product2.Name', 'Product2.Forms__c'};
            
    public Map<String,ObjectField> colMetadata {get;private set;}
    
    public String colMetadataJson {get {return JSON.serializePretty(colMetadata);}private set;}
    
    
    
    public Boolean listViewHasField(String fName){
        return colMetadata.containsKey(fName);
    }
    
    public Boolean getListViewIsEvent(){
        return listViewHasField('Product2.Event__c');
    }
    
    private String formatWhereClause(String param){
        if(null == param) return null;
        String[] params = param.split(',');
        return String.join(params,' AND ');
    }
    
    
    
    
    public ClickpdxOrderItems(){
        p = ApexPages.currentPage().getParameters();
		
        String product2Id;
        
        String orderByClause;
        
        //Order Item List View Fields Default
        String listViewName = null == p.get('view') ? 'OrderItemListViewFields' : p.get('view');
        
        String colJson = [SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt  WHERE DeveloperName = :listViewName LIMIT 1].ClickpdxCore__Value__c;

        String whereClause = p.get('whereClause');
        
        ListView thisList;
        
        communityUrl = [SELECT Domain,DomainType FROM Domain LIMIT 1].Domain;
        
		cols = DEFAULT_ATTENDEE_FIELDS;
        colMetadata = new Map<String,ObjectField>();

        colMetadata = (Map<String,ObjectField>)JSON.deserialize(colJson, Map<String,ObjectField>.class);
       
        List<ObjectField> fieldOrder = colMetadata.values();
        fieldOrder.sort();
        
		cols = new List<String>();
        
        for(ObjectField f :fieldOrder){
            cols.add(f.fieldName);
        }
        
        // Set relevant cookie info
        thisList = getAppPreferences();

        thisList = mergeLists(thisList,new ListView(p));
        
        // Set defaults
        thisList.order = thisList.order == null ? 'ASC' : thisList.order;
        thisList.orderColumn = null == thisList.orderColumn ? 'Order.EffectiveDate' : thisList.orderColumn;
        setAppPreference('appPreferences',thisList);

        
        eventId = thisList.listId;
        product2Id = thisList.productFilter;
        orderByClause = thisList.orderColumn+' ' + thisList.order + thisList.nullOrder;
        
        
        retUrl = null != thisList.listId ? '/apex/ClickpdxOrderItems?eventId='+thisList.listId : '/apex/ClickpdxOrderItems';

        
        this.events = getEventList();

        whereClause = formatWhereClause(whereClause);
        
        
        if(null != whereClause){
            theQuery = getOrderItemsByWhereClause(whereClause, orderByClause);
        }
        else if(null == eventId && null == product2Id){
            theQuery = getAllOrderItems(orderByClause);
        }
        else if(null == eventId & null != product2Id){
            theQuery = getOrderItemsByProductId(product2Id, orderByClause);
        }
        else if(null == thisList.productFilter){
            theQuery = null == eventId ? getAllOrderItems(orderByClause) : getOrderItems(eventId, orderByClause);
        } else {
            theQuery = getOrderItemsByProductId(product2Id, orderByClause);
        }

        lines = Database.query(theQuery);
    }
    
    
    
    @RemoteAction
    public static List<OrderItem> updateLine(OrderItem line){
        
        update line;
        return new List<OrderItem>{line};
    }
    
    
    
    // List a is the saved settings.
    // List b are any new settings passed via URL.
    private ListView mergeLists(ListView a, ListView b){
        Id productFilter;
        ListView ret = new ListView();

        ret.listId = b.listId != null ? b.listId : a.listId;
        ret.order = b.order != null ? b.order : a.order;
        ret.orderColumn = b.orderColumn != null ? b.orderColumn : a.orderColumn;
        ret.productFilter = b.productFilter != null ? b.productFilter : a.productFilter;

        if(b.listId != null && b.productFilter == null) {
          ret.productFilter = null;  
        } 
        
        if(a.orderColumn == b.orderColumn){
            ret.order = a.order == 'ASC' ? 'DESC' : 'ASC';
        }
        
        ret.nullOrder = ret.order == 'ASC' ? ' NULLS FIRST ' : ' NULLS LAST ';
        
        return ret;
    }
    
    
    
    public List<Product2> getTicketTypes(){ 
        // query for the name of product related to the specified event.
        List<Product2> products = new List<Product2>();
        
        if(null == this.eventId){
            return products;
        }
		List<Product2> addProducts = [SELECT Id, Name FROM Product2 WHERE Event__c = :this.eventId];
        
        products.addAll(addProducts);
        
        return products;
    }

    
    private String getSelectFieldList(String[] fList){
        return String.join(fList,QUERY_FIELD_SEPARATOR);
    }

    
    public String getOrderItems(Id eventId, String orderBy){

        String queryString = 'SELECT '+ getSelectFieldList(cols.size()>0 ? cols : DEFAULT_ATTENDEE_FIELDS) +
                       ' FROM OrderItem WHERE Product2.Event__c = \''+eventId+'\' AND Product2.IsAddOn__c != True AND Order.Status != \'Draft\' ORDER BY '+orderBy;
        return queryString;
    }
 

    public String getOrderItemsByWhereClause(String whereClause, String orderBy){
        
        String queryString = 'SELECT  '+getSelectFieldList(cols.size()>0 ? cols : DEFAULT_ATTENDEE_FIELDS)+
                       ' FROM OrderItem WHERE '+whereClause+' AND Product2.IsAddOn__c != True ORDER BY '+orderBy;
        
        return queryString;
    }
    
    public String getOrderItemsByProductId(Id product2Id, String orderBy){
        Map<String,Object> filters = new Map<String,Object>{'Product2.Id'=>product2Id};
            String[] wheres = new String[]{};
                for(String fName :filters.keySet()){
                    wheres.add(fName + '='+ '\''+filters.get(fName)+'\'');
                }
        String whereClause = String.join(wheres,' AND ');
        
		return 'SELECT  '+getSelectFieldList(cols.size()>0 ? cols : DEFAULT_ATTENDEE_FIELDS)+
                       ' FROM OrderItem WHERE '+whereClause+' ORDER BY '+orderBy;
    }


    /**
     * This is the default executed when the Attendee App loads.
     */
    private String getAllOrderItems(String orderBy){

        String queryString = 'SELECT '+getSelectFieldList(cols.size()>0 ? cols : DEFAULT_ATTENDEE_FIELDS)+
                       ' FROM OrderItem ORDER BY '+orderBy + ' LIMIT 25';
        
        return queryString;
    }
    

    
    private List<SelectOption> getEventList(){
        Date p1 = System.today().addDays(-7);
        Date today = System.today();
		Date past = Date.newInstance(2020,1,1);
        
        List<Event__c> recent = [SELECT Id, Name, Start_Date__c FROM Event__c WHERE Start_Date__c >= :p1 ORDER BY Name ASC LIMIT 20];        
        List<Event__c> events = [SELECT Id, Name, Start_Date__c FROM Event__c WHERE Start_Date__c >= :past ORDER BY Name ASC, Start_Date__c DESC ];



        List<SelectOption> eventOptions = new List<SelectOption>();
        
        
		eventOptions.add(new SelectOption('','-- RECENT EVENTS --'));
        
        for(Event__c e : recent){
            String theDate = e.Start_Date__c.format('MMM d');
            eventOptions.add(new SelectOption(e.Id,theDate + ' - ' + e.Name));
        }

        
		eventOptions.add(new SelectOption('',''));        
		eventOptions.add(new SelectOption('','-- ALL EVENTS --'));
        
        // If the event is already listed as recent then make it disabled.
        for(Event__c e : events){
            SelectOption opt = recent.contains(e) ? new SelectOption(e.Id + '-Z', e.Name + ' (see above)', True) : new SelectOption(e.Id,e.Name);
            eventOptions.add(opt);
        }
        

        
        return eventOptions;
    }
    
    

    
    
    

    global class ObjectField implements Comparable {
        public String fieldName {get;private set;}
        
        public String machineName {get {
            return fieldName.toLowerCase().replace(' ','-').replace('__','-').replace('.','-');
        }private set;}
        
        public Boolean isVisible {get;private set;}
        
        public String alias {get;private set;}
        
        public String fieldType {get;private set;}
        
        public String references {get;private set;}
        
        public Integer order {get;private set;}
        
        public String value {get;set {
            if(fieldType == 'localDate'){
                value = 'foobar';
            }
            else {
                value = value;
            }
        }}
        
        public ObjectField(String fName){
            fieldName = fName;
            isVisible = True;
        }
        
        global Integer compareTo(Object o){
            ObjectField obj = (ObjectField)o;
            if (order == obj.order) return 0;
            if (order > obj.order) return 1;
            return -1; 
        }
    }
    
    public class ListView {
        
        public String listId;
        
        public String orderColumn;
        
        public String order;
        
        public String productFilter;
        
        public String nullOrder;
        
        public ListView(){
            this.order = 'ASC';
            this.listId = null;
            this.productFilter = null;
            this.orderColumn = 'Order.EffectiveDate';
            this.nullOrder = ' NULLS FIRST ';
        }
        
        public ListView(Map<String,String> params){
            this.listId = params.get('eventId');
            this.orderColumn = params.get('orderBy');
            this.order = params.get('order');
            this.productFilter = params.get('product2Id');
        }
    }
    
    
    
    
    
    
    

    
    public static void evaluateOrderItemProductGrants(Map<Id,OrderItem> triggerMap, Integer evaluationContext){
        if(evaluationContext == PRODUCT_GRANTS_EVALUATE_ON_LINES) {
            evaluateOrderItemProductGrantsOnLines(triggerMap.values());
        } else if(evaluationContext == PRODUCT_GRANTS_EVALUATE_ON_PARENT_LINES){
            evaluateOrderItemProductGrantsOnParentLines(triggerMap);
        }
    }
    
    public static void evaluateOrderItemProductGrantsOnLines(List<OrderItem> triggerNew){
        
        Map<Id,PricebookEntry> relatedPricebookEntries = new Map<Id,PricebookEntry>();
        List<Id> relatedPricebookEntryIds = new List<Id>();
        
        for(OrderItem item :triggerNew){
            relatedPricebookEntryIds.add(item.PricebookEntryId);
        }
        
        relatedPricebookEntries.putAll([SELECT Id, Product2Id, Product2.Name, Product2.GrantField__c, Product2.GrantValue__c FROM PricebookEntry WHERE Id = :relatedPricebookEntryIds]);
        
        for(OrderItem p :triggerNew){
			Id key = p.PricebookEntryId;
            if(null == key) throw new OrderItemException('This Order Item was not assigned a Product.');
            String grantFieldName = relatedPricebookEntries.get(key).Product2.GrantField__c;
            String grantFieldValue = relatedPricebookEntries.get(key).Product2.GrantValue__c;
            
            if(null == grantFieldName || null == grantFieldValue) continue;
            p.put(grantFieldName,grantFieldValue);
            // needsUpdate.put(p.Id,p); Not necessary when doing a before-insert
        }
        
        // filteredTriggerMap.put()
        
        
        // if(null == needsUpdate || 0 == needsUpdate.size()) return;
        
        // We don't need explicitly call insert.
        //   The Trigger will take care of this.
        //     but perhaps we could do a check for a Trigger context
        //       and this might be called standalone in the future.
        // insert needsUpdate.values();
    }

    
    public static void evaluateOrderItemProductGrants(Map<Id,OrderItem> triggerMap){
        evaluateOrderItemProductGrantsOnParentLines(triggerMap);
    }

    
    public static void evaluateOrderItemProductGrantsOnParentLines(Map<Id,OrderItem> triggerMap){
        
        // For each OrderItem in the triggerList
        //   determine which have parent items
        Map<Id,Id> parentsToProducts = new Map<Id,Id>();
        Map<Id,OrderItem> parents;
        Map<Id,Product2> products;
        Map<Id,OrderItem> needsUpdate = new Map<Id,OrderItem>();
        
        for(OrderItem item :triggerMap.values()){
            if(null == item.ParentLineId__c) continue;
            parentsToProducts.put((Id)item.ParentLineId__c,item.Product2Id);
        }
        
        if(0 == parentsToProducts.size()) return;
        
        products = new Map<Id,Product2>([SELECT Id, Name, GrantField__c, GrantValue__c FROM Product2 WHERE Id = :parentsToProducts.values()]);
        parents = new Map<Id,OrderItem>([SELECT Id, Note_1__c, Note_2__c, Note_3__c FROM OrderItem WHERE Id = :parentsToProducts.keySet()]);
        
        if(0 == products.size() || 0 == parents.size()) return;
        
        for(OrderItem p :parents.values()){
            Id key = parentsToProducts.get(p.Id);
            if(null == key) continue;
            String grantFieldName = products.get(key).GrantField__c;
            String grantFieldValue = products.get(key).GrantValue__c;
            
            if(null == grantFieldName || null == grantFieldValue) continue;
            p.put(grantFieldName,grantFieldValue);
            needsUpdate.put(p.Id,p);
        }
        
        if(null == needsUpdate || 0 == needsUpdate.size()) return;
        
        upsert needsUpdate.values();
         
    }
    

    /**
     * @method evaluateOrderItemProductGrantsOnLinesRevised
     * 
     * @description update either OrderItem or related records
     * 
     * @author José Bernal
     * 
     */
    public static void evaluateOrderItemProductGrantsOnLinesRevised(List<OrderItem> triggerNew){
        
        Map<Id,PricebookEntry> relatedPricebookEntries = new Map<Id,PricebookEntry>();
        
        List<Id> relatedPricebookEntryIds = new List<Id>();
        
        List<SObject> records = new List<SObject>();        
        
        for(OrderItem item :triggerNew){
            relatedPricebookEntryIds.add(item.PricebookEntryId);
        }
        
        relatedPricebookEntries.putAll([SELECT Id, Product2Id, Product2.Name, Product2.GrantField__c, Product2.GrantValue__c
                                        FROM PricebookEntry WHERE Id = :relatedPricebookEntryIds]);
        
        for(OrderItem line :triggerNew){
			Id key = line.PricebookEntryId;
            if(null == key) throw new OrderItemException('This Order Item was not assigned a Product.');
            String grantFieldName = relatedPricebookEntries.get(key).Product2.GrantField__c;
            String grantFieldValue = relatedPricebookEntries.get(key).Product2.GrantValue__c;
            
            if(null == line.Contact__c || null == grantFieldName || null == grantFieldValue) continue; // only useful if both fields are defined.
            
            if(grantFieldName != 'Contact__r.OcdlaCapitalDefendersExpiration__c') continue;

            SObject tmp = fetchRecordUpdate(line.Contact__c, grantFieldName, grantFieldValue);
            
            records.add(tmp);
        }
        
        update records;
    }

    
    private static SObject fetchRecordUpdate(Id recordId, String grantFieldName, String grantFieldValue){
        Contact rec = new Contact();
        rec.Id = recordId;
        rec.put('OcdlaCapitalDefendersExpiration__c',Date.newInstance(2020, 6, 30));
        
        return rec;
    }
  
    
    public void setAppPreference(String appId, ListView settings) {
			Cookie appPreferences;
			Integer THIRTY_DAYS = 86400 * 30;
			String js;

			js = JSON.serialize(settings);
			
			String sortColumnName;
			String sortOrder = 'ASC';
			
        if(null != js){
			appPreferences = new Cookie(appId, js, null, THIRTY_DAYS, False);
        }
			// Set the new cookie for the page
			ApexPages.currentPage().setCookies(new Cookie[]{appPreferences});
    }
    
    public ListView getAppPreferences(){
        Map<String,System.Cookie> cookies;
		System.Cookie prefs;
        String js;
        
        cookies = ApexPages.currentPage().getCookies();
        prefs = cookies.get('appPreferences');
        if(null == prefs) return new ClickpdxOrderItems.ListView();
        
        js = prefs.getValue();
        
        if(null == js) return new ClickpdxOrderItems.ListView();
        return (ListView)JSON.deserialize(js, ClickpdxOrderItems.ListView.class);
    }


    
    
    private class OrderItemException extends Exception {}
    
}