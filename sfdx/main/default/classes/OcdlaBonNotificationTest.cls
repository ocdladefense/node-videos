@isTest
public class OcdlaBonNotificationTest {

    
    static String recordPrefix = 'TEST002'; 
     
    private static final String MEMBERSHIP_SUBCATEGORY_OPERATOR = 'Membership';
    
    private static final String PRODUCT_OPTION_FLAG = 'Option';
    
    public Account a;
    
    public Contact c;
    
    public Order o;
    
    public OrderItem line;
    
    public Product2 ticket;
    
    public PricebookEntry entry; 
    
    
    public OcdlaBonNotificationTest(){
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];
        this.o = [SELECT Id, Status FROM Order LIMIT 1];
        // List<OrderItem> lines = [SELECT Id, ExpirationDate__c, Contact__r.Id FROM OrderItem WHERE OrderId = :this.o.Id];

		System.assertNotEquals('Activated', this.o.Status, 'This test Order has already been Activated.');
        

        // System.assert(lines.size() > 0, 'There are no Order Products (OrderItems) associated with the test Order.');

		// PriceBook2 nonMember = [SELECT Id, Name FROM PriceBook2 WHERE Name = :OrgOcdla.NON_MEMBER_PRICE_BOOK_NAME LIMIT 1];
        
		// this.ticket = [SELECT Id, Name, ProductCode FROM Product2 WHERE Id IN(SELECT Product2Id FROM PricebookEntry WHERE PriceBook2Id = :nonMember.Id)];
        
		this.entry = [SELECT Id, UnitPrice FROM PricebookEntry LIMIT 1];
        
        this.line = new OrderItem(OrderId = this.o.Id, Description = 'Unit Test product.', PricebookEntryId = this.entry.Id, Quantity = 1.00, UnitPrice = 1.00, Contact__c = this.c.Id);
		insert line;
        
        
        this.line = [SELECT Id, PricebookEntryId, Quantity, UnitPrice, Contact__c FROM OrderItem WHERE Id = :line.Id];
        line.Description = 'Unit Test Product';
        update line;
        
        List<OrderItem> theLines = [SELECT Id, Contact__c FROM OrderItem];
        for(OrderItem l :theLines){
            l.Contact__c = this.c.Id;
        }
        
        update theLines;
        
        // System.assertNotEquals(null, line.Contact__r.Id, 'No Contact is set on this Order Product.');
    }
    
    @testSetup static void setup() {
        ClickpdxTest.setup(recordPrefix);
    }
    
    
    static testMethod void doBonNotification(){ 
        OcdlaBonNotificationTest context;
        Map<Id,Messaging.SingleEmailMessage> newMemberEmails;
        EmailTemplate theTemplate;
		OcdlaBonNotification bon;
        
        context = new OcdlaBonNotificationTest();
        
        Test.startTest();

        bon = new OcdlaBonNotification();
        bon.getCandidateLineItemsFirstNotice(System.today());
        bon.getCandidateLineItemsSecondNotice(System.today());
        bon.hasNotifications();
        bon.sendSecondNotificationEmail();
        bon.executeMe();
        
        Test.stopTest();      
    }
    
    
    static testMethod void generateBonEmailPreview(){
        OcdlaBonNotificationTest context;
        Map<Id,Messaging.SingleEmailMessage> newMemberEmails;
        EmailTemplate theTemplate;
		OcdlaBonNotification bon;
        OrderItem theOrderProduct;
        
        context = new OcdlaBonNotificationTest();
        
        // theOrderProduct = [SELECT Id, Contact__r.Id FROM OrderItem WHERE Id = :context.line.Id];
        // theOrderProduct.Contact__c = 
        
        // System.assertNotEquals(null,theOrderProduct.Contact__r.Id);
 
        
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            theTemplate = ClickpdxMail.createEmailTemplate('New Member Welcome Email');
            theTemplate.Subject = 'Welcome {!Contact.FirstName}';
            theTemplate.Body = '{!OrderItem.Id} {!Contact.FirstName}';
            theTemplate.HtmlValue = 'Dear {!Contact.FirstName}, Your Order Id was: {!OrderItem.Id}.';
            insert theTemplate;
        } 
        
        Test.startTest();

        bon = new OcdlaBonNotification();
        OcdlaBonNotification.generateEmailPreview(context.line.Id, theTemplate.Name);
        OcdlaBonNotification.testEmails(new List<Id>{context.line.Id}, theTemplate.Name);
        
        Test.stopTest();      
    }
    

    
}