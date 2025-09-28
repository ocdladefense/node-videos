public without sharing class DocumentTemplateProcessor implements Mergeable {

    public Boolean includeStaffSignatures {get; private set;}
    
    private Map<String,String> mergeFields {get; set;}
    
    public Map<String,Object> record {get; private set;}
    
    public List<SObject> records {get; private set;}
    
    public String getBody() { return null; }
    
    private DocumentTemplate__c tpl {get; private set;}

    



    public DocumentTemplateProcessor(ApexPages.StandardSetController controller) {
        this.records = controller.getSelected();
    }
    
    

    
    public DocumentTemplateProcessor() {
        User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Map<String,String> params = ApexPages.currentPage().getParameters();
        
        String contactIdP = params.get('contactId');
        String tplId = params.get('tplId');
        String whatId = params.get('whatId');
        
        
        Id contactId = null == u.ContactId ? '003j000000rU9NvAAK' : u.ContactId;
        contactId = null != contactIdP ? contactIdP : contactId;
        
		init(tplId, contactId, whatId);
    }  


    
    public DocumentTemplateProcessor(String tplId, Id contactId) {
		this(tplId, contactId, null);
		includeStaffSignatures = False;
    }
    
    
    public DocumentTemplateProcessor(String tplId, Id contactId, String whatId) {
		includeStaffSignatures = False;
     	init(tplId, contactId, whatId);   
    }
    
    
    public Map<String,String> getAvailableMergeFields() {
        
        mergeFields = new Map<String,String>();
        mergeFields.put('FirstName', 'The donor\'s first name.');
        mergeFields.put('LastName', 'The donor\'s last name.');
        mergeFields.put('TotalAmount', 'The total of donations for the specified time period.');
        
        return mergeFields;
    }
    
    
    
    public void init(String tplId, Id contactId, Id whatId) {
        // Get current user contact and do the query;
        record = new Map<String,Object>();

		tpl = [SELECT Name, Subject__c, HtmlBody__c, Signatures__c, EffectiveDate__c FROM DocumentTemplate__c WHERE Id = :tplId];
        
        Contact c = [SELECT FirstName, LastName, MailingStreet, MailingCity, MailingStateCode,
                              MailingPostalCode, MailingCountryCode, Ocdla_Organization__c FROM Contact WHERE Id = :contactId];
        
		Map<String,Object> recordData = c.getPopulatedFieldsAsMap();

        
        Decimal totalAmount = 0.00;
        
        List<Decimal> prodSerialNumbers = 	new List<Decimal>{43,44,160,212,961,941,942,943,946,961,962,963,964};
            								
        Date startDate = date.newInstance(tpl.EffectiveDate__c.year(), 1, 1);
        Date endDate = date.newInstance(tpl.EffectiveDate__c.year(), 12, 31);
        
        List<OrderItem> donations = [SELECT TotalPrice FROM OrderItem WHERE Product2.Ocdla_Product_Serial_Number__c = :prodSerialNumbers 
                                     AND Contact__c = :contactId
                                     AND Order.EffectiveDate >= :startDate AND Order.EffectiveDate <= :endDate];
        
        for(OrderItem line : donations) {
            totalAmount += line.TotalPrice;
        }
        
        for(String key :recordData.keySet()) {
            record.put(key, recordData.get(key));
        }
        
        String mailingStreet = null == c.MailingStreet ? '' : c.MailingStreet;
        
        mailingStreet = mailingStreet.replace('\r\n', '<br />');
        mailingStreet = mailingStreet.replace('\n', '<br />');
        mailingStreet = mailingStreet.replace('\r', '<br />');
                
        record.put('FirstName', c.FirstName);
        record.put('LastName', c.LastName);
        record.put('MailingStreet', mailingStreet);
        record.put('MailingCity', null == c.MailingCity ? '' : c.MailingCity);
        record.put('MailingStateCode', null == c.MailingStateCode ? '' : c.MailingStateCode);
        record.put('MailingPostalCode', null == c.MailingPostalCode ? '' : c.MailingPostalCode);
        record.put('MailingCountryCode', null == c.MailingCountryCode ? '' : c.MailingCountryCode);
        record.put('Organization', String.isEmpty(c.Ocdla_Organization__c) ? '' : c.Ocdla_Organization__c);
        record.put('Ocdla_Organization__c', String.isEmpty(c.Ocdla_Organization__c) ? '' : c.Ocdla_Organization__c);
                   
        String MailingAddress = !String.isEmpty(c.MailingStreet) ? (c.MailingStreet + '<br />' + c.MailingCity + ', ' + c.MailingStateCode + ' ' + c.MailingPostalCode) : '';
        record.put('MailingAddress', MailingAddress);
        
        record.put('TotalAmount', totalAmount);
    }
    
    
    public String getHeading() {
        String name = record.get('FirstName') + ' ' + record.get('LastName');
        String org = (String)record.get('Organization');
        String address = (String)record.get('MailingAddress');
        
        if(String.isEmpty(org)) {
            return name + '<br />' + address;
        }
        else {
            return name + '<br />' + org + '<br />' + address;
        }
    }  


    
    public Component.Apex.OutputText getMessageBody() {

        // Was probably tyring to abstract this so that other specific Mergeable
        // classes could implement Mergeable to render more specific OutputText components.
        // Obviously, we have co-opted what should be a more general class (this class) to do
        // things specific to the annual donation summary letters.
        // System.Type t = System.Type.forName(this.mergeableName);
        // Mergeable forMerge = (Mergeable)t.newInstance();
        
		String tplBody = tpl.HtmlBody__c;
        tplBody = tplBody.replace('\r\n', '');
        tplBody = tplBody.replace('\n', '');
        tplBody = tplBody.replace('\r', '');
        
        Component.Apex.OutputText body = new Component.Apex.OutputText();
        body.escape = False;
        body.expressions.value = tplBody;
              
		return body;
    }

    
    
    
}