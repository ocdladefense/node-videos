global class OcdlaCustomOrderEntrySave extends ClickpdxOrder.OrderEntryController.DefaultOrderSave {
    
    public OcdlaCustomOrderEntrySave(){
        super(new Map<String,Object>{
            'contactQuery' => setContactQuery(),
            // 'accountQuery' => '',
            'productQuery' => setProductQuery(),
            'lineQuery' => setLineItemQuery()
        });
    }

    
    private static String[] setContactQuery(){
        String[] fields = new String[]{'Id','Name','AccountId','FirstName','LastName','Title','Salutation','Account.Name',
            'Email','Phone','MailingCity','MailingState',
            'MailingPostalCode','MailingCountry'};
               return fields; 
              //  String query = 'SELECT '+String.join(fields,',')+' FROM Contact';
        
      //  return query;
    }

    private static String[] setLineItemQuery(){
        String[] fields = new String[]{'Id','OrderId','PriceBookEntryId','Product2Id','Product2.Name','Description',
            'Quantity','UnitPrice','TotalPrice','Contact__c','Note_1__c','Note_2__c','Note_3__c'};
                
                String query = 'SELECT '+String.join(fields,',')+' FROM Contact';
        
        return fields;
    }
    
    private static String[] setProductQuery(){
        String[] fields = new String[]{'Id','Product2Id','Product2.ProductCode','Product2.Name','UnitPrice','IsActive'};
                return fields;
               // String query = 'SELECT '+String.join(fields,',')+' FROM Contact';
        
        //return query;
    }
    
    
        public override Map<String,OrderItem> updateOrderLines(SObject order, Map<Id,OrderItem> original, Map<String,OrderItem> newLines, List<Map<String,String>> post){

           	Map<String,OrderItem> returnLines = new Map<String,OrderItem>();
            
            // Handle Line Items
            for(Map<String,String> line: post){
				OrderItem theLineItem;
				Id lineId;
                String key;
                String cid;
                String qty;
                Boolean isNew;
                
                line.get('cid');
                
                lineId = (null == line.get('Id') || '' == line.get('Id').trim()) ? null : (Id)line.get('Id');
                
                key = null != lineId ? (String)lineId : cid;
                
                isNew = null == lineId;
                
                theLineItem = new OrderItem();
                theLineItem.OrderId = order.Id;
                

                qty = (null == line.get('Quantity') || '' == line.get('Quantity')) ? '1' : line.get('Quantity');

                theLineItem.Note_1__c = line.get('Note_1__c');
                theLineItem.Note_2__c = line.get('Note_2__c');
                theLineItem.Note_3__c = line.get('Note_3__c');
                
                
                Id contactId;
                
                contactId =  (null == line.get('Contact__c') || '' == line.get('Contact__c').trim()) ? null : (Id)line.get('Contact__c');
                
                theLineItem.Contact__c = contactId;
                
                theLineItem.Description = line.get('Description');
 
                theLineItem.Quantity = Decimal.valueOf(qty);
                
                if(null != line.get('UnitPrice') && '' != line.get('UnitPrice')){
                    theLineItem.UnitPrice = Decimal.valueOf(line.get('UnitPrice'));             	   
                }
                
                theLineItem.ClickpdxOrder__Cid__c = line.get('cid');

                if(isNew){
                    theLineItem.PricebookEntryId = (Id)line.get('PricebookEntryId');
                    theLineItem.Id = null;
                }
                
                else if(original.get(lineId).PricebookEntryId != (Id)line.get('PricebookEntryId')){
                    theLineItem.put('PricebookEntryId',(Id)line.get('PricebookEntryId'));
					theLineItem.Id = null;                    
                }
                
                else {
                    theLineItem.PricebookEntryId = (Id)line.get('PricebookEntryId');
                    theLineItem.Id = lineId;
                }

                returnLines.put(key,theLineItem); 
            }
            
            return returnLines;
        }

}