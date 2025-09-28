global class ProductConfirmationEmail extends MailGenerator {

    
    private OrderItem record;
    
    
    
    public ProductConfirmationEmail(OrderItem record) {
        this.record = record;
    }
    
    
    public ProductConfirmationEmail() {}
    
    
    
    public String getSubject() {
		return record.Product2.ConfirmationEmailSubject__c;
    }
    
    
    public String getBody() {
		return record.Product2.ConfirmationEmailBody__c;
    }
    
    public Id getWhoId() {
        return null == record.Contact__c ? record.Order.BillToContactId : record.Contact__c;
    }
    
    public Id getWhatId() {
        return record.Id;
    }
    
    public String getTo() {
        return null == record.Contact__c ? record.Order.BillToContact.Email : record.Contact__r.Email;
    }
    
    public List<String> getQueryFields() {
        return new List<String>{
            'Id',
            'Product2Id',
            'Order.BillToContactId','Order.BillToContact.Email',
            'PricebookEntryId',
            'Contact__c',
            'Contact__r.FirstName',
            'Contact__r.LastName',
            'Contact__r.Email',
            'Product2.ConfirmationEmailSubject__c',
            'Product2.ConfirmationEmailBody__c'
        };
        //FROM OrderItem WHERE Id = :this.recordIds
    }
    
    
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds) {
        
        MessageWhoIdWhatId whoIsIt;
        
        Id productId = recordIds[0];
        
        Account a = new Account(Name='My Test Account');
        insert a;
        
        Contact c = new Contact(FirstName = 'Jane',LastName='Doe',Email='jbernal.web.dev@gmail.com',AccountId=a.Id);
        insert c;
        
        PricebookEntry entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :productId LIMIT 1];
        
        Order o = new Order(EffectiveDate=System.today(),Status='Draft',PriceBook2Id = ClickpdxCore.Application.config.getStdPriceBookId(),AccountId=a.Id);
        insert o;
        
        OrderItem line = new OrderItem(Contact__c=c.Id, LastName__c = c.LastName,OrderId=o.Id, PricebookEntryId = entry.Id, Quantity = 1.0,UnitPrice=1.00); 
        insert line;

        
        return new MessageWhoIdWhatId(c.Id,line.Id);
    }
    
      
    /*
     *  Should return a MailMessage object
     *   appropriate to this class.
     */
    public override List<MailMessage> getMessages(){
 
        List<OrderItem> lines;

        
        lines = [SELECT Id, Product2Id, Order.BillToContactId, Order.BillToContact.Email, PricebookEntryId, Contact__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email,
                 Product2.ConfirmationEmailSubject__c, Product2.ConfirmationEmailBody__c FROM OrderItem WHERE Id = :this.recordIds];
        
        
		List<MailMessage> emails = new List<MailMessage>();

        for(OrderItem line :lines) {
            
            ProductConfirmationEmail data = new ProductConfirmationEmail(line);
            // Each Product potentially has a template.  
            // Abstract the subject/body parts of the template into a template object.
            // This object can be used later.
  
            MailMessageTemplate tpl = new MailMessageTemplate(data.getSubject(),data.getBody());            
            
        	// Id whoId = null == line.Contact__c ? line.Order.BillToContactId : line.Contact__c;
            // Id whatId = line.Id;
            // String to = null == line.Contact__c ? line.Order.BillToContact.Email : line.Contact__r.Email;
              
            MailMessage email = new MailMessage(data.getWhoId(), data.getWhatId());
            email.setTo(data.getTo());
			email.setTemplate(tpl);
            
            emails.add(email);
        }
        
        return emails;
    }
}