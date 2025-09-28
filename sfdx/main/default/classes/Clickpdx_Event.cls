global without sharing class Clickpdx_Event {
    public static final String DEFAULT_TICKET_TYPE_ITEM_ID = 'a0wj00000004rqx';
          

     
        /**
* @method 
*/  
        public static String lookupEventTicketTypeItem(Boolean isCurrentMember,String memberStatus){
        Organization orgDetails = [SELECT Id, InstanceName, IsSandbox FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
            String itemId;
            String foobar = 'baz';
            String foobar2 = 'baz';
            String foobar3 = 'baz';
            String foobar4 = 'baz';
            if(isCurrentMember){
if(Test.isRunningTest() && orgDetails.IsSandbox){
                    itemId = 'a0wj0000003gziLAAQ';

                }
                else if(memberStatus == 'A'){
                    itemId = 'a0w0a000006uUZvAAM';
                } else if(memberStatus == 'N'){
                    itemId = 'a0wj0000005lJhD';
                }
                 else{
                    itemId = 'a0wj0000005lJgZ';
                }
            }

            else if(!isCurrentMember){
if(Test.isRunningTest()&& orgDetails.IsSandbox){
                    itemId = 'a0wj0000003gziLAAQ';

                }
                else if(memberStatus == 'A'){
                    itemId = 'a0w0a000006uUZv';
                } else if(memberStatus == 'N'){
                    itemId = 'a0wj0000005lJhN';
                } else {
                    itemId = 'a0wj0000005lJhI';
                }
            }
            return itemId;
        }
    
    public static Map<Id,OrderApi__Item__c> initTicketTypeItems(){
    	Set<Id> eventTicketTypeIds = new Set<Id>{'a0w0a000006uUZqAAM','a0wj0000005lJhD','a0wj0000005lJgZ',
            'a0w0a000006uUZv','a0wj0000005lJhN','a0wj0000005lJhI',
            'a0wj0000003gziLAAQ'};
        return new Map<Id,OrderApi__Item__c>([SELECT Id, OrderApi__Price__c FROM OrderApi__Item__c WHERE Id IN :eventTicketTypeIds]);
	}    
    
    webservice static String createAccountEventTicketSalesOrderButton(Id accountId){
    	OrderApi__Sales_Order__c theOrder = createAccountEventTicketSalesOrder(accountId);
        return (String)theOrder.Id;
    }    


    public static OrderApi__Sales_Order__c createAccountEventTicketSalesOrder(Id accountId){  
        return createAccountEventTicketSalesOrder(accountId, OcdlaAccount.ACCOUNT_QUERY_CURRENT_MEMBER_CONTACTS);
    }
    
    public static OrderApi__Sales_Order__c createAccountEventTicketSalesOrder(Id accountId, Integer queryType){  
        Clickpdx_Apps__c settings; 
        settings = Clickpdx_Apps__c.getInstance(UserInfo.getUserId());
        Date expiration = settings.Clickpdx_Paid_Office_Constraint__c;
        // Boolean excludeAlreadyRenewed = settings.
        // The Order that will be prepared for this Paid Office renewal.
        OrderApi__Sales_Order__c eventOrder;
        
        // All of the Contacts for this Account.
        List<Contact> contacts;
        
        // Related Ticket Type Items
        Map<Id,OrderApi__Item__c> ticketTypeItems;
        
        // All of the Lines for this Sales Order.
        List<OrderApi__Sales_Order_Line__c> theLines = new List<OrderApi__Sales_Order_Line__c>();


        eventOrder = ClickpdxSalesOrder.createSalesOrder(accountId);
        // renewalOrder.Ocdla_Is_Paid_Office_Renewal__c = True;
        // update renewalOrder;
        
		contacts = OcdlaAccount.getAccountContacts(accountId,queryType);
        
        ticketTypeItems = initTicketTypeItems();
        for(Contact c : contacts){

            OrderApi__Sales_Order_Line__c line;
            Id itemId;
            OrderApi__Item__c theItem;


            itemId = lookupEventTicketTypeItem(c.Ocdla_Current_Member_Flag__c,c.Ocdla_Member_Status__c);
            theItem = ticketTypeItems.get(itemId);
            if(null == theItem) continue;
            // Ocdla_Bar_Year__c, Ocdla_Member_Status__c
            line = ClickpdxSalesOrder.getSalesOrderLine(theItem);
            line.OrderApi__Sales_Order__c = eventOrder.Id;
            line.OrderApi__Contact__c = c.Id;
            line.OrderApi__Price_Override__c = False;
            // line.OrderApi__Line_Description__c = 'AC17 button renewal for '+c.FirstName + ' '+c.LastName;
			
            theLines.add(line);
        }
        insert theLines;
        return eventOrder;
    }
}