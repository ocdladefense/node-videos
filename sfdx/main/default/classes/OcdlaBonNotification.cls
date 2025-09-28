global class OcdlaBonNotification implements ClickpdxScheduler.ISchedulable, ClickpdxMail.ISendable {
    
    
    final static Boolean USE_TEST_DATA = True;
    
    private static Id emailTemplateId;
    
    private String searchString = 'Books Online';
    
	// Minimum number of days prior to any expiration 
    final static Integer FIRST_NOTICE_WINDOW_DAYS = 30; 

	// Minimum number of days prior to any expiration     
    final static Integer SECOND_NOTICE_WINDOW_DAYS = 15; 
    
    final static String BON_BCC_ADDRESS = 'admin@ocdla.org';
    
    String FIRST_NOTICE_ANNOTATION = 'First Notification Email';
    
    String SECOND_NOTICE_ANNOTATION = 'Second Notification Email';
    
   	final static Boolean BON_SEND_SECOND_NOTIFICATION_EMAIL = False;
    
    Map<Id,OrderItem> forNotification = new Map<Id,OrderItem>();
    
    List<Id> firstNotices;
    
    Set<Id> onlyContacts;
    
    // Query to retrieve the Ids of candidate items for renewal notices.
    private String itemQuery = 'SELECT Id, Product2.Id FROM PricebookEntryId WHERE Product2.Name LIKE \'%Books Online%\'';    
    
    // Debugging code to determine how available object members when
    // testing Scheduled Apex.
    public Boolean isDestroyed = True;
    
    public OcdlaBonNotification(Set<Id> onlyContacts){
		this.isDestroyed = False;
        this.onlyContacts = onlyContacts;
    }
    
    public OcdlaBonNotification(){
		this.isDestroyed = False;
    }
    
    
    public Boolean hasNotifications(){
        return forNotification.size() > 0;
    }
    

    global void execute(SchedulableContext sc){
     	executeMe();   
    }
    
    private Boolean hasActivity(List<EmailActivity> activities, EmailActivity theSearch){
        if(null == activities || activities.size() == 0){
            return False;
        }
        
        for(EmailActivity ea :activities){
            if(ea.Token == theSearch.Token) return True;
        }
        
        return False;
    }
    
    
    global String executeMe(){  
        
        // Don't send to already-expired subscriptions.
        Date limitDate = System.today();
        
        // The renewal window will be different between first and second notices.
        Date firstNoticeRenewalWindow = System.today() + FIRST_NOTICE_WINDOW_DAYS;
        
        
        if(!Test.isRunningTest() && USE_TEST_DATA){
        	forNotification = getCandidateLineItemsTest();
        } else {
            forNotification = getCandidateLineItemsFirstNotice(firstNoticeRenewalWindow);
        }

        if(Test.isRunningTest()){
			System.assertEquals(System.today().addDays(FIRST_NOTICE_WINDOW_DAYS), firstNoticeRenewalWindow, 'The calculated renewal window dates do not match.');
        }
        
        // Perform a query for the Order Products to be sent Renewal notifications.
        
        for(Id lineId :forNotification.keySet()){
            OrderItem line = forNotification.get(lineId);
            
            if(hasActivity(getOrderItemActivities(line),new EmailActivity('BON Renewal First Notice'))){
                forNotification.remove(lineId);
            }
        }
        
        if(forNotification.size() > 0){
            sendEmails(forNotification.keySet(), 'BON Renewal First Notice');
            saveEmailActivity(forNotification.values(),'BON Renewal First Notice');
        }
        
        if(BON_SEND_SECOND_NOTIFICATION_EMAIL){
            sendSecondNotificationEmail();            
        }

        
        return 'some status';
    }
    
    
    
    public void sendSecondNotificationEmail(){
        Map<Id,OrderItem> forNotification = new Map<Id,OrderItem>();
        Date secondNoticeRenewalWindow = System.today() + SECOND_NOTICE_WINDOW_DAYS;
        
        if(!Test.isRunningTest() && USE_TEST_DATA){
        	forNotification = getCandidateLineItemsTest();
        } else {
            forNotification = getCandidateLineItemsSecondNotice(secondNoticeRenewalWindow);
        }
        
        for(Id lineId :forNotification.keySet()){
            OrderItem line = forNotification.get(lineId);
            
            if(hasActivity(getOrderItemActivities(line),new EmailActivity('BON Renewal First Notice'))){
                forNotification.remove(lineId);
            }
        }
        
        if(forNotification.size() > 0){
            sendEmails(forNotification.keySet(), 'BON Renewal First Notice');
			saveEmailActivity(forNotification.values(),'BON Renewal Second Notice');
        }

        if(false)
        throw new BonException(String.valueOf(forNotification.size()));
    }

    
    
    
    private void saveEmailActivity(List<OrderItem> orderItems, String emailToken){
		List<EmailActivity> activities;
        List<OrderItem> theLines;
        
        activities = new List<EmailActivity>();
        
        for(OrderItem line :orderItems){
            String toJson;
            EmailActivity aLatest;
            List<EmailActivity> aPrevious;
            List<EmailActivity> aNew;
            
            
            aLatest = new EmailActivity(emailToken);
            aLatest.ActivityDate = System.now();
            
            aPrevious = getOrderItemActivities(line);
            aNew = updateOrderItemActivities(aPrevious,aLatest);

			toJson = JSON.serialize(aNew,false);
            line.Activities__c = toJson;
        }
        
        update orderItems;
    }
    
    // ActivityDate
    // Token
    private List<EmailActivity> updateOrderItemActivities(List<EmailActivity> aPrevious, EmailActivity aNew){
        Boolean hasActivity = False;
        Integer i = 0;
        
        for(EmailActivity ea :aPrevious){
            if(ea.Token == aNew.Token){
                hasActivity = True;
                break;
            }
            
            i++;
        }
        
        if(hasActivity){
			aPrevious.set(i,aNew);
        } else {
            aPrevious.add(aNew);
        }
        
        return aPrevious;
    }
    
    
    private List<EmailActivity> getOrderItemActivities(OrderItem line){
		String theJson;
        List<EmailActivity> activities = new List<EmailActivity>();
        
        theJson = line.Activities__c;
        
        if(null != line.Activities__c){
            activities.addAll((List<EmailActivity>)JSON.deserialize(theJson,List<EmailActivity>.class));
        }
        
		return activities;                
    }
    
    
    public Map<Id,OrderItem> getCandidateLineItemsTest(){
		return new Map<Id,OrderItem>([SELECT Id, Activities__c, Contact__c, Contact__r.Id, PricebookEntryId, ExpirationDate__c FROM OrderItem WHERE Id='802Q0000001JF1z']);
    }
    
    
    
    public Map<Id,OrderItem> getCandidateLineItemsFirstNotice(Date windowDate){
		Map<Id,OrderItem> lines = new Map<Id,OrderItem>();
        
        lines.putAll([SELECT Id, Activities__c, Contact__r.Id, Contact__c, PricebookEntryId, ExpirationDate__c FROM OrderItem WHERE ExpirationDate__c <= :windowDate]);
        
        return lines;
    }
    
    
    public Map<Id,OrderItem> getCandidateLineItemsSecondNotice(Date windowDate){
		Map<Id,OrderItem> lines = new Map<Id,OrderItem>();
        
        lines.putAll([SELECT Id, Activities__c, Contact__c, Contact__r.Id, PricebookEntryId, ExpirationDate__c FROM OrderItem WHERE ExpirationDate__c <= :windowDate]);
        
        return lines;
    }


    
    private static EmailTemplate getEmailTemplate(String name){
        List<EmailTemplate> t;
        
        t = [SELECT Id, Body, HtmlValue  FROM EmailTemplate WHERE name = :name LIMIT 1];
        if(null == t || t.size() < 1){
            throw new BonException('Could not locate an email template for, '+name);
        }
        
        return t[0];
    }
    
    public class BonException extends Exception {
        
    }
    
    webservice static List<String> generateEmailPreview(Id orderItemId, String emailTemplateName){
        String body;
        Messaging.SingleEmailMessage m;
        EmailTemplate theTemplate;
        OrderItem item;
        String templateHtmlValue;
        
        item = [SELECT Id, Contact__r.Id, ExpirationDate__c FROM OrderItem WHERE Id = :orderItemId];
        
        if(null == item){
            throw new OcdlaMail.OcdlaEmailException('The Order Product cannot be found.');
        }
        
        if(null == item.Contact__r.Id){
            throw new OcdlaMail.OcdlaEmailException('The Contact for this Order Product has not been set.');
        }
        
        
        theTemplate = getEmailTemplate(emailTemplateName);
        // templateHtmlValue = theTemplate.HtmlValue.replaceAll( '<!\\[CDATA\\[', '' ).replaceAll( ']]>', '' );
        templateHtmlValue = theTemplate.Body;
        
        // m = Clickpdx_Mail.getEmailPreview(getTemplateId(), item.Contact__r.Id, item.Id);
        body = OcdlaMail.doMerge(templateHtmlValue, item.Contact__r.Id, item.Id);
        
        return new List<String>{body};
    }
    
    private static Boolean testEmails(Set<Id> orderItemIds, String emailTemplateName){
        List<Id> theIds = new List<Id>();
        theIds.addAll(orderItemIds);
        
        return testEmails(theIds,emailTemplateName);
    }
    
    private static Boolean sendEmails(Set<Id> orderItemIds, String emailTemplateName){
        List<Id> theIds = new List<Id>();
        theIds.addAll(orderItemIds);
        
        return sendEmails(theIds,emailTemplateName);
    }
    
    webservice static Boolean testEmails(List<Id> orderItemIds, String emailTemplateName){
        EmailTemplate theTemplate;
        List<OrderItem> items;
        String templateBody;
        
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'info@ocdla.org'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            
        }
        
        items = [SELECT Id, Description, Contact__r.Id, Contact__r.Email, ExpirationDate__c FROM OrderItem WHERE Id = :orderItemIds];
        
        if(null == items || items.size() < 1){
            throw new OcdlaMail.OcdlaEmailException('The Order Product cannot be found.');
        }
        
        
        theTemplate = getEmailTemplate(emailTemplateName);
        templateBody = theTemplate.Body;
        
        
        for(OrderItem item :items){
            if(null == item.Contact__r.Id){
                throw new OcdlaMail.OcdlaEmailException('MAIL_NOT_SENT_ERROR: The Contact for this Order Product, "'+item.Description+'", has not been set.');
            }
        }
        
        for(OrderItem item :items){
            Messaging.SingleEmailMessage m;
            String body;

			m = new Messaging.SingleEmailMessage();            
        	body = OcdlaMail.doMerge(templateBody, item.Contact__r.Id, item.Id);
            // Construct an SingleMailMessage instance for each email
            m.setHtmlBody(body);
            m.setToAddresses(new List<String>{UserInfo.getUserEmail()});
            m.setSubject('Books Online Renewal - '+generateRandomString());//First Notice foobar');
			m.setOrgWideEmailAddressId(owea.get(0).Id);
            // m.setReferences(generateId());
            OcdlaMail.addToQueue(m);
        }
        
        OcdlaMail.send();
        
        return True;
    }
    
    
    webservice static Boolean sendEmails(List<Id> orderItemIds, String emailTemplateName){
        EmailTemplate theTemplate;
        List<OrderItem> items;
        String templateBody;
        
        if(null == orderItemIds || orderItemIds.size() == 0){
            throw new OcdlaMail.OcdlaEmailException('No Order Items were passed to this method.');
        }
        
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'info@ocdla.org'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            
        }
        
        items = [SELECT Id, OrderItemNumber, Description, Contact__r.Id, Contact__r.Email, ExpirationDate__c FROM OrderItem WHERE Id = :orderItemIds];
        
        if(null == items || items.size() < 1){
            throw new OcdlaMail.OcdlaEmailException('The Order Product cannot be found.');
        }
        
        
        theTemplate = getEmailTemplate(emailTemplateName);
        templateBody = theTemplate.Body;
        
        
        for(OrderItem item :items){
            if(null == item.Contact__r.Id){
                throw new OcdlaMail.OcdlaEmailException('MAIL_NOT_SENT_ERROR: The Contact for this Order Product, "'+item.Description+'", has not been set.');
            }
        }
        
        for(OrderItem item :items){
            Messaging.SingleEmailMessage m;
            String body;

            // Construct an SingleMailMessage instance for each email
			m = new Messaging.SingleEmailMessage();            
        	body = OcdlaMail.doMerge(templateBody, item.Contact__r.Id, item.Id);

            m.setHtmlBody(body);
            m.setToAddresses(new List<String>{item.Contact__r.Email});
            
            m.setCcAddresses(getBccAddresses());
            m.setSubject('Books Online Renewal - (#'+item.OrderItemNumber+')');//First Notice foobar');
			m.setOrgWideEmailAddressId(owea.get(0).Id);
            // m.setReferences(generateId());
            OcdlaMail.addToQueue(m);
        }
        
        OcdlaMail.send();
        
        return True;
    }
    
    
    public class EmailActivity {
        
        public DateTime ActivityDate;
        
        public String Token;
        
        public String Subject;
        
        public String Body;
        
        public EmailActivity(){}
        
        public EmailActivity(String t){
            Token = t;
        }
        
    }


    
    public static List<String> getBccAddresses(){
        return new List<String>{BON_BCC_ADDRESS};
    }
        
    public static String generateRandomString() {
		Integer len = 8;
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
 
    
    
}