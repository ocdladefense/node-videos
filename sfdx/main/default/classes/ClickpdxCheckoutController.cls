global without sharing class ClickpdxCheckoutController extends CommunityController {
	
    Opportunity opp {get; private set;}
    
    Contact defaultContact;
    
    Map<Contact,List<ClickpdxCartItem>> orderLines = new Map<Contact,List<ClickpdxCartItem>>();
    
    public Boolean isSandbox {get; private set;}
    
    public Contact BillToContact {get; private set;}
    
    public Boolean isLoggedIn {get; private set;}
    
    public Boolean hasAuthNetCustomerProfile {get {return null != this.BillToContact.AuthorizeDotNetCustomerProfileId__c;}private set;}
    
    public Boolean isTest {get;private set;}
    
    public String shoppingCartSummary {get;private set;}
    
    public String cartId {get;private set;}
    
    public Boolean isEmptyOrder {get;private set;}
    
    public Boolean isPaid {get;private set;} 
    
    public Boolean renderPayment {get;private set;}
    
    public Boolean isFreeCart {get;private set;}
    
    public Boolean hasShippableProducts {get {return ClickpdxShoppingCart.hasShippableProducts(this.cartId);}private set;}
    
    public Boolean allowManageCart {get;private set;}
    
    private static final String AUTH_NET_CUSTOMER_PROFILE_ENDPOINT = 'authNet/getCustomerProfile';
    
    private static final String AUTH_NET_PAYMENT_PROFILE_ENDPOINT = 'authNet/getCustomerPaymentProfile';
    
    /** END MEMBER VARIABLES **/
    
    public Boolean getRenderPayment(){
        return this.renderPayment;
    }
    
    public Boolean getIsEmptyOrder(){
        return this.isEmptyOrder;
    }
    
    public Opportunity getOpp(){
        return this.opp;
    }
    
    public Boolean getIsPaid(){
        return this.IsPaid;
    }
    

    
    public PageReference redirectIfSobjectError(){
		return OrgOcdla.redirectTo(OrgOcdla.SHOPPING_CART_REGENERATE_OPPORTUNITY_PAGE);
    }
    
    
   //  @isTestVisible
    public void setDefaults(){
        this.isPaid = False;
        this.renderPayment = False;
        this.cartId = null;
        this.allowManageCart = True;
        this.defaultContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :OrgOcdla.getGuestCheckoutAccountId() LIMIT 1];
        Map<Id,Contact> orderContacts = new Map<Id,Contact>();
        Map<String,ClickpdxCartItem> cart = new Map<String,ClickpdxCartItem>();
        this.shoppingCartSummary = '';
        this.isEmptyOrder = True;
        this.opp = new Opportunity();
    } 
    
    
    public ClickpdxCheckoutController(ApexPages.StandardController controller){}
    
    public void setupContact(){
        User u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        this.isLoggedIn = null == u.ContactId ? False : True;
        
        if(!isLoggedIn) {
            this.BillToContact = new Contact();
        }
        else {
            this.BillToContact = [SELECT Id, AccountId, FirstName, LastName, Email, AuthorizeDotNetCustomerProfileId__c FROM Contact WHERE Id = :u.ContactId];
        }
    }
    
    public ClickpdxCheckoutController() {
        this.setupContact();
		Map<String,String> params = ApexPages.CurrentPage().getParameters();
        this.isTest = null != params.get('test') ? True : False;
        
        
        this.isSandbox = OrgOcdla.isSandbox();
        
        List<Opportunity> opps = [SELECT Id, Name, Amount, StageName, AccountId, Contact__c FROM Opportunity WHERE Id = :params.get('Id')];
        
        
        if(null == opps || opps.size() < 1){
            setDefaults();
            return;
        } else {
            this.opp = opps[0];
            this.allowManageCart = opps[0].Name != 'Paid Office Membership Renewal';
        }
        
        this.isFreeCart = !(this.opp.Amount > 0.00);

		this.hasShippableProducts = False;
        
        this.isPaid = this.opp.StageName == 'Closed Won' ? True : False;
        
        this.renderPayment = !this.isPaid || this.isTest ? True : False;
        
        this.cartId = this.opp.Id;

        this.defaultContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :this.opp.AccountId LIMIT 1];
        
        List<ClickpdxCartItem> theLines = ClickpdxCartItem.loadOpportunityLineItemsFromOpportunityId(this.opp.Id);

        if(null == theLines || theLines.size() < 1) {
            this.isEmptyOrder = True;
            
        } else {
            this.isEmptyOrder = False;

            String otherItemsText = theLines.size() == 2 ? String.valueOf(theLines.size()-1) + ' other item.' : String.valueOf(theLines.size()-1) + ' other items.'; 
            String orderSizeSummary = theLines.size() > 1 ? ' and '+ otherItemsText : '';
            this.shoppingCartSummary = theLines[0].getProductName() + orderSizeSummary;
            
			this.groupShoppingCartLines(theLines);
        }
    }
    
    @TestVisible
    private void groupShoppingCartLines(List<ClickpdxCartItem> theLines){
        
        List<Id> theContactIds = new List<Id>();
        Map<Id,Contact> orderContacts = new Map<Id,Contact>();
        
        for(ClickpdxCartItem line :theLines){
            if(null == line.contactId) continue;
            theContactIds.add(line.contactId);
        }
        
        orderContacts.putAll(new Map<Id,Contact>([SELECT Id, Name, FirstName, LastName FROM Contact WHERE Id = :theContactIds]));
        
        for(ClickpdxCartItem line :theLines){
            Contact c = null == orderContacts.get(line.contactId) ? this.defaultContact : orderContacts.get(line.contactId);
            
        	if(orderLines.get(c) == null){
                orderLines.put(c,new List<ClickpdxCartItem>{line});
            } else { 
                orderLines.get(c).add(line);
            }
        }
    }
    
    public String getCartName(){
        return this.opp.Name;
    }
    
    public String getCartSummary(){
        return this.shoppingCartSummary;
    }
    
    public String getCartTotal(){
        return String.valueOf(this.opp.Amount);
    }
    
    
    public Map<Contact,List<ClickpdxCartItem>> getOrderLines(){
        return this.orderLines;
    }
    
    public String getOrderEmail(){
        Boolean isGuestAccount = False;
        String email = this.defaultContact.Email;
        
        return email;
    }
    
    public class CCResponse {
        String respCode;
        String transactionId;
        String profileId;
    }



    
    public static Id getRelatedOrderId(Id oppId){
		List<Order> related = [SELECT Id FROM Order WHERE OpportunityId = :oppId];
        return (null == related || related.size()<1) ? null : related[0].Id;
    }
    
    

    @RemoteAction
    global static Order processOrderStub(Id oppId, Map<String,String> billingData){
        Opportunity opp = [SELECT Id, Name, AccountId, PriceBook2Id, Contact__c FROM Opportunity WHERE Id = :oppId];
        Order o;

        o = ClickpdxOrder.newFromShoppingCart(opp,billingData);
        o.Id = getRelatedOrderId(oppId);
        
        upsert o;
        
        o = [SELECT Id, OrderNumber, EffectiveDate, Status, OpportunityId, AccountId, BillToContactId,
                               ShipToContactId, PriceBook2Id FROM Order WHERE Id = :o.Id];

        
        return o;
    }
    
    
    /**
     * @method processShoppingCart
     * 
     * @description Convert the Shopping Cart Opportunity to an Order.
     * 
     * @params
     *   - String oppId, the Id of the Opportunity to be converted.
     */
    @RemoteAction
    public static Order finalizeOrder(String orderId, Map<String,String> ccResp){
        
        Order o = new Order();
        o.Id = orderId;
        o.Payment_Info__c = JSON.serialize(ccResp);
        o.Origin__c = 'Web Order';
        
        upsert o;
        
		ClickpdxOrder.draftOrderLinesFromShoppingCart(o.Id);
        
		ClickpdxOrder.activateOrder(orderId);
        
        return [SELECT Id, Payment_Info__c, Origin__c FROM Order WHERE Id = :orderId];
    }
    


    
    @RemoteAction
    global static List<Contact> checkOrderEmail(String email){
       String out = email.trim();
        
       Map<String,String> resp = new Map<String,String>();
        
       List<Contact> c = [SELECT FirstName, LastName, Email, MailingStreet, MailingPostalCode, MailingCity, Ocdla_Address_Line_1__c, 
                          Ocdla_Address_Line_2__c, MailingStateCode, AccountId, Account.Name FROM Contact WHERE Email = :out OR OrderApi__Work_Email__c = :out];
       
       return c;
    }
    
    @RemoteAction
    global static Boolean attachAccount(Contact c, String oppId){
        Id accountId;
        
        // accountId = 
        Opportunity opp = new Opportunity(Id = oppId, AccountId = c.AccountId, Contact__c=c.Id);
        update opp;
        return True;
    }

    
    
    @RemoteAction
    global static Contact generateGuestCheckoutContact(Contact c, String oppId){
        String firstName = c.FirstName;
        String lastName = c.LastName;
        String emails = c.Email;
        
        
        
        
        Contact guest = new Contact(AccountId = OrgOcdla.getGuestCheckoutAccountId(), 
                                    FirstName = c.FirstName,
                                    LastName = c.LastName,
                                    Email = c.Email,
                                    OrderApi__Work_Email__c = c.Email);
        
        insert guest;
        attachAccount(guest,oppId);
        return guest;
    }    
 
    
    
/*  
    @RemoteAction
    global static OrderApi__Sales_Order__c getOrderApiSalesOrderData(Id orderApiSalesOrderId){
   		OrderApi__Sales_Order__c order;
        
        order = [SELECT Id, Name, OrderApi__Total__c, OrderApi__Item_Count__c, OrderApi__Contact__r.Id, OrderApi__Contact__r.FirstName,
                 OrderApi__Contact__r.LastName, OrderApi__Contact__r.Ocdla_Address_Line_1__c, OrderApi__Contact__r.MailingCity,
                 OrderApi__Contact__r.MailingStateCode, OrderApi__Contact__r.MailingPostalCode
                 FROM OrderApi__Sales_Order__c WHERE Id = :orderApiSalesOrderId];
        
        return order;
    }
*/ 
    
	@RemoteAction
    public static Map<String,String> getCustomerProfile(Map<String,String> paramsSent){
        Map<String,String> params;
        String domain;
        
        domain = (String)ClickpdxCore.Application.config.get('AUTH_NET_PROXY_SERVER');
        params = new Map<String,String>();
        params.putAll(paramsSent);
        
        
        params.put('domain',domain);
        params.put('endpoint',AUTH_NET_CUSTOMER_PROFILE_ENDPOINT);
        
        return ClickpdxCore.Api0_1.doDefaultHttpCallout(params);
    }
    
	@RemoteAction
    public static Map<String,String> getCustomerPaymentProfile(Map<String,String> paramsSent){
        Map<String,String> params;
        String domain;
        
        domain = (String)ClickpdxCore.Application.config.get('AUTH_NET_PROXY_SERVER');
        params = new Map<String,String>();
        params.putAll(paramsSent);

        
        params.put('domain',domain);
        params.put('endpoint',AUTH_NET_PAYMENT_PROFILE_ENDPOINT);
        
        return ClickpdxCore.Api0_1.doDefaultHttpCallout(params);
    }


    /*
    @RemoteAction
    global static Order finalizeOrderApiSalesOrder(OrderApi__Sales_Order__c orderApiOrder){
        
        orderApiOrder.OrderApi__Status__c = 'Closed';
        orderApiOrder.OrderApi__Posting_Status__c = 'Posted';
        upsert orderApiOrder;
        
        OrderApi__Sales_Order__c theOrder = [SELECT Id, Name, OrderApi__Total__c, OrderApi__Contact__c, OrderApi__Account__c
                                             FROM OrderApi__Sales_Order__c WHERE Id = :orderApiOrder.Id];
        Order o = new Order(); 
        o.OrderApi_Sales_Order__c  = theOrder.Id;
        // o.TotalAmount = theOrder.OrderApi__Total__c;
        o.EffectiveDate = System.today();
        o.AccountId = theOrder.OrderApi__Account__c;
        o.Status = 'Attempted Payment';
        insert o;
        
        o = [SELECT Id, Name, OrderNumber FROM Order WHERE Id = :o.Id];
        
        return o;
    }
    */
	
}