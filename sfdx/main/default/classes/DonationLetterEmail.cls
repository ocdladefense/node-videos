global class DonationLetterEmail extends MailGenerator {

    

    
    
    public DonationLetterEmail(Id recordId) {
		this.recordIds.add(recordId);
    }
    
    public DonationLetterEmail() {
        
    }  
    

    
    public override MessageWhoIdWhatId getSampleWhoIdWhatId(List<Id> recordIds) {
        
        MessageWhoIdWhatId whoIsIt;
        
        Account a = new Account(Name='My Test Account');
        insert a;
        
        Contact c = new Contact(AccountId=a.Id,FirstName = 'Jane',LastName='Doe',Email='jbernal.web.dev@gmail.com');
        insert c;        
        

        return new MessageWhoIdWhatId(c.Id,null);
    }
    

  

      
    public override List<MailMessage> getMessages() {
    
		System.debug(data);
        List<DocumentInstance__c> letters = [SELECT Id, Name, Total__c, Contact__c, DocumentTemplate__c FROM DocumentInstance__c WHERE Id = :recordIds];
		List<MailMessage> emails = new List<MailMessage>();

        // Collect Contact information from Set<Id> (Contact__c).
        for(DocumentInstance__c letter :letters) {
			MailMessage msg = new MailMessage(letter.Contact__c, letter.Id);
            // msg.setTo('jbernal.web.dev@gmail.com');
            
            Blob data = getData(letter.DocumentTemplate__c, letter.Contact__c, letter.Id);
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment pdf = toEmailAttachment(data);
            attachments.add(pdf);
            msg.setFileAttachments(attachments);
            
            emails.add(msg);
        }

        
        // Collection of MailMessage objects.
        // The iterator will apply the template specified in setTemplate().
        // MailMessageIterator queue = new MailMessageIterator(emails);
        // queue.setTemplate(tpl);
        
        // MailClient client = new MailClient();
        // client.send(queue);
        
        return emails;
    }
    

    // https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_System_PageReference_getContent.htm
    // You can’t use the getContent method in:
	// Triggers
	// Test methods. If you use getContent in a test method, the test method fails. getContent is treated as a callout in API version 34.0 and later.
	// Apex email services
    public static Blob getData(Id tplId, Id contactId, Id whatId) {
        ApexPages.PageReference r = new PageReference('/apex/DocumentLetter');
        // r.getParameters().put('csv', '1');
        r.getParameters().put('tplId', tplId);
        r.getParameters().put('contactId', contactId);
        r.getParameters().put('whatId', whatId);
        
        return Test.isRunningTest() ? Blob.valueOf('TEST PDF') : r.getContent();
    }

    
    public static Messaging.EmailFileAttachment toEmailAttachment(Blob data) {
     
    	return toEmailAttachment(data, 'attachment.pdf');
    }
    
    public static Messaging.EmailFileAttachment toEmailAttachment(Blob data, String filename) {

        Messaging.EmailFileAttachment csv = new Messaging.EmailFileAttachment();


        csv.setFileName(filename);
        csv.setBody(data);
        csv.setContentType('application/pdf');

        return csv;
    }
    
    
    public override void afterSend(List<MailSendStatus> results) {
        

    }

    

}