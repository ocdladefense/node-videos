public class CsvUpload {


    public Blob blobData {public get; public set;}
    
    public String fileData {public get; public set;}
    
    public Boolean createOrders {public get; public set;}
 
    
    public List<Map<String,String>> lines {public get; private set;}
    
    private List<Order> orders = new List<Order>();
    
      
    public CsvUpload() {
		lines = new List<Map<String,String>>();
        createOrders = False;
    }
    
    public PageReference doCancel() {
        return null;
    }    
    
    public PageReference removeFile() {
        return null;
    }
    
    
    
    public PageReference doSubmit() {

        CsvParser parser = new CsvParser();

        
        CsvIterator it = parser.parse(this.fileData);
        List<Order> orders = new List<Order>();
	
        while(it.hasNext()) {
            Map<String,String> line = new Map<String,String>();
            
            CsvRow row = it.next();
            if(row.isBlank()) continue;
			if(row.get('AMS') == 'X') continue;
            
            System.debug(row.getFieldMap());
           
            String c = row.get('Contact');
            // System.debug('Contact (from field 0) is: '+field);
            // System.debug('Contact (from map) is: '+c);
            
            Contact cLookup;
            List<String> errors = new List<String>();
            
            try {
                cLookup = CsvContactLookup.lookup(c);
            } catch(LookupException e) {
                System.debug('Contact Lookup Error: '+e.getMessage());
                errors.add(e.getMessage());
            } 
            
            line.put('Contact',c);
            line.put('ContactLink', (null == cLookup ? '' : '/'+cLookup.Id));
            
            line.put('Product',row.get('Product'));
            // Parse the products:
            String productCodes = row.get('Product');
            
            // Get a list of the product data that will be added to the Order.
            String unitPrices = row.get('Unit Price');
            String totalAmount = row.get('Amount');
            String prices = !String.isEmpty(unitPrices) ? unitPrices : totalAmount;
            List<String> notes = new List<String>();
            notes.add(row.get('Note 1'));
            notes.add(row.get('Note 2'));
            notes.add(row.get('Note 3'));            
            List<Map<String,Object>> productData = this.parseProductCodes(productCodes, prices, notes, null == cLookup ? False : cLookup.Ocdla_Current_Member_Flag__c);
            List<String> productDescriptions = parseProductDescriptions(productData);
            line.put('Description', String.join(productData,'<br />'));
            line.put('Errors', String.join(errors,'<br />'));
            
            
            lines.add(line);
            
            if(createOrders == True && !(errors.size() > 0)) {
            	Order o = this.createOrder(cLookup, productData);
				orders.add(o);
            }
            


        }
    
        if(createOrders) {
            for(Order o : orders) {
                o.Status = 'Posted Payment';
            }
            
            update orders;
        }
        
        return null;
    }
      
    public Order createOrder(Contact c, List<Map<String,Object>> productData) {
        
        Order o = new Order(Name='OCDLA Shopping Cart Order',AccountId = c.AccountId, Status='Draft',Origin__c='CSV Upload',Pricebook2Id=CsvUtils.getStdPriceBookId());
        o.SkipEmailReceipt__c = True;
        o.EffectiveDate = Date.newInstance(2025,3,14);
        o.BillToContactId = c.Id;
        o.ShipToContactId = c.Id;
        o.PostingEntity__c = 'Receipt';
        
        List<OrderItem> lines = new List<OrderItem>();
        
        insert o;
        
        for(Map<String,Object> prod :productData) {
            OrderItem line = new OrderItem(OrderId=o.Id,Contact__c=c.Id);
            line.PricebookEntryId = (Id)prod.get('PriceBookEntryId');
            line.UnitPrice = (Decimal)prod.get('UnitPrice');
            line.Quantity = (Integer)prod.get('Qty');
            line.Note_1__c = (String)prod.get('Note_1');
            line.Note_2__c = (String)prod.get('Note_2');
            line.Note_3__c = (String)prod.get('Note_3');
            
            lines.add(line);
        }

        insert lines;

        return o;
    }
      
    

    
    public List<Map<String,Object>> parseProductCodes(String data, String prices, List<String> notes, Boolean isMember) {
        List<Map<String,Object>> productData = new List<Map<String,Object>>();
        List<String> entries = data.split(','); 
		List<String> unitPrices = prices.split(',');
        
        for(Integer index=0; index<entries.size(); index++) { //String entry : entries) {
            Map<String,Object> prod = new Map<String,Object>();
            String entry = entries[index];
            entry = entry.trim();
            
            // We really should be using regex here to distinguish between the alphanumerics that represent the product code
            // and the (optional) numeric (in parentheses) that represents the quantity.
            // Below, taken from: https://stackoverflow.com/questions/36943806/get-all-captured-groups-in-java
            // Further discussion at: https://docs.oracle.com/javase/1.5.0/docs/api/index.html?java/util/regex/Pattern.html
            /* Integer i = 0;
while (matcher.find()) {
   for (Integer j = 0; j <= matcher.groupCount(); j++) {
      System.out.println("------------------------------------");
      System.out.println("Group " + i + ": " + matcher.group(j));
      i++;
   }
}*/
            entry = entry.replace(' (','-');
            entry = entry.replace(')','');
            
            String[] parts = entry.split('-');
            
            try {
                // Lookup product, Name, Price.
                PricebookEntry pbentry = CsvProductLookup.lookup(parts[0]);
                prod.put('Qty', parts.size() > 1 ? Integer.valueOf(parts[1]) : 1);
                prod.put('Name', pbentry.Product2.Name);
                prod.put('PriceBookEntryId', pbentry.Id);
                prod.put('UnitPrice', Decimal.valueOf(unitPrices[index]));//isMember ? pbentry.Product2.ClickpdxCatalog__MemberPrice__c : pbentry.Product2.ClickpdxCatalog__StandardPrice__c);
                prod.put('Note_1', notes[0]);
                prod.put('Note_2', notes[1]);
                prod.put('Note_3', notes[2]);
            } catch(LookupException e) {
                prod.put('Error', e.getMessage());
            }
            productData.add(prod);
        }

        
        return productData;
    }
    
    
    public List<String> parseProductDescriptions(List<Map<String,Object>> productData) {
        List<String> descriptions = new List<String>();
        for(Map<String,Object> data : productData) {
            
            if(null != data.get('Error')) {
                descriptions.add((String)data.get('Error'));
                continue;
            }
            
            String name = (String)data.get('Name');
            String qty = 'Qty: '+String.valueOf((Integer)data.get('Qty'));
            String unitPrice = 'UnitPrice: '+String.valueOf((Decimal)data.get('UnitPrice'));
            
            List<String> desc1 = new List<String>();
            desc1.add(name);
            desc1.add(qty);
            desc1.add(unitPrice);
            
            descriptions.add(String.join(desc1,', '));
        }
        
        return descriptions;
    }


}