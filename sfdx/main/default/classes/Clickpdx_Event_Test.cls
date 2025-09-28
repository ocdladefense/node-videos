@isTest(SeeAllData=true) 
public class Clickpdx_Event_Test {
    static testMethod void testAccountEventPurchase(){
        Clickpdx_Test_Base tma = new Clickpdx_Test_Base();
        Account a;
        Contact c1; 
        Contact c2;
        List<Contact> contacts;
        List<Contact> contacts2;
        Organization org;
        String appropriateTicket1;
        String appropriateTicket2;
        Map<Id,OrderApi__Item__c> ticketTypeItems;
        
        org = [SELECT Id, InstanceName, IsSandbox FROM Organization WHERE Id = :UserInfo.getOrganizationId()];

        c1 = tma.c;
        a = tma.a;
        c2 = c1.clone(False,True);
        // c2.Ocdla_Current_Member_Flag__c = False;
        upsert c2;
        
        test.startTest();
        ticketTypeItems = Clickpdx_Event.initTicketTypeItems();
        appropriateTicket1 = Clickpdx_Event.lookupEventTicketTypeItem(c1.Ocdla_Current_Member_Flag__c,
                                                                     c1.Ocdla_Member_Status__c);
        
        appropriateTicket2 = Clickpdx_Event.lookupEventTicketTypeItem(c2.Ocdla_Current_Member_Flag__c,
                                                                     c2.Ocdla_Member_Status__c);
        
        // For the purposes of testing get all Contacts
        // since we can't be sure the Org has any current members.
        contacts = OcdlaAccount.getAccountContacts(a.Id,OcdlaAccount.ACCOUNT_QUERY_ALL_CONTACTS);
    	contacts2 = OcdlaAccount.getAccountContacts(a.Id, True, Date.newInstance(2017, 6, 30));
        
        Boolean hasContacts = contacts.size() > 0 ? true : false;
        // The account should have at least one contact
        System.assert(hasContacts);
          
        if(org.IsSandbox){
            System.assertEquals(appropriateTicket1,'a0wj0000003gziLAAQ');
        } 
        else if(c1.Ocdla_Current_Member_Flag__c){
            System.assertEquals(appropriateTicket1,'a0w0a000006uUZvAAM');
        }
        else {
            System.assertEquals(appropriateTicket1,'a0w0a000006uUZv');            
        }
        System.assertNotEquals(null, ticketTypeItems.get(appropriateTicket1));

        System.assertEquals(c1.Ocdla_Member_Status__c,'A');

        String orderId = Clickpdx_Event.createAccountEventTicketSalesOrderButton(tma.a.Id);
        OrderApi__Sales_Order__c theOrder2 = Clickpdx_Event.createAccountEventTicketSalesOrder(tma.a.Id,OcdlaAccount.ACCOUNT_QUERY_ALL_CONTACTS);
          
        /*
Id objectId = theOrder.OrderApi__Contact__c;
System.assert(objectId != null);

Id whatId = theOrder.Id;
System.assert(whatId != null);
*/
        test.stopTest();
    }
}