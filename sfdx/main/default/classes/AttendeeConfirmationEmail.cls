public class AttendeeConfirmationEmail extends MailGenerator {

    
      
      
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds) {
        
        MessageWhoIdWhatId whoIsIt;
        
        Id productId = recordIds[0];
        
        Account a = new Account(Name='My Test Account');
        Contact c = new Contact(FirstName = 'Jane',LastName='Doe',Email='jbernal.web.dev@gmail.com');
        
        PricebookEntry entry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :productId LIMIT 1];
        
        insert a;
        c.AccountId = a.Id;
        insert c;
        
        Order o = new Order(EffectiveDate=System.today(),Status='Draft',PriceBook2Id = ClickpdxCore.Application.config.getStdPriceBookId(),AccountId=a.Id);
        insert o;
        
        OrderItem line = new OrderItem(Contact__c=c.Id, FirstName__c=c.FirstName, LastName__c = c.LastName,OrderId=o.Id, PricebookEntryId = entry.Id, Quantity = 1.0,UnitPrice=1.00); 
        insert line;

        
        return new MessageWhoIdWhatId(c.Id,line.Id);
    }
    

      
    
    /*
     *  Should return a EmailMessage object
     *   appropriate to this class.
     */
    public override List<MailMessage> getMessages(){
 
        List<OrderItem> lines;

        
        lines = [SELECT Id, Order.BillToContact.Email, Email__c, Product2Id, PricebookEntryId, Contact__c, Contact__r.FirstName,
                 Contact__r.LastName, Contact__r.Email,
                 Product2.Event__r.EventConfirmationEmailSubject__c,
				Product2.Event__r.EventConfirmationEmail__c FROM OrderItem WHERE Id = :this.recordIds];

		List<MailMessage> emails = new List<MailMessage>();

        for(OrderItem line :lines) {
            
            // Each Product potentially has a template.  
            // Abstract the subject/body parts of the template into a template object.
            // This object can be used later.
            String tpls = line.Product2.Event__r.EventConfirmationEmailSubject__c;
            String tplb = line.Product2.Event__r.EventConfirmationEmail__c;
            MailMessageTemplate tpl = new MailMessageTemplate(tpls,tplb);
            
            
        	Id whoId = line.Contact__c;
            Id whatId = line.Id;
            Boolean hasContactEmail = null != line.Email__c || null != line.Contact__r.Email;
			String to;
            
            if(hasContactEmail) {
            	to = null != line.Email__c ? line.Email__c : line.Contact__r.Email;
             } else {
             	to = line.Order.BillToContact.Email;    
             }
            
            MailMessage email = new MailMessage(whoId, whatId);
            email.setTo(to);
            email.setTemplate(tpl);
            emails.add(email);
        }
        
        return emails;
    }
    
    

    public override void afterSend(List<MailSendStatus> results) {
        
		List<OrderItem> affectedItems = new List<OrderItem>();
        
        for(MailSendStatus status :results) {
            if(!status.isSuccess) continue;
            OrderItem line = new OrderItem(Id=status.whatId);
            line.ConfirmationSentDate__c = System.now();
            
            affectedItems.add(line);
        }
        
        update affectedItems;
    }
    
    
    
}