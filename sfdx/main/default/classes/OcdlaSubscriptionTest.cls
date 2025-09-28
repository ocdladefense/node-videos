@isTest
private class OcdlaSubscriptionTest {
    static Integer TestBatchSize = 500;
    
    static Integer MEMBERSHIP_EXPIRATION_MONTH = 6;
    
    static Integer MEMBERSHIP_EXPIRATION_DAY = 30;
    
    static Integer MEMBERSHIP_EXPIRATION_ADD_ONE_MONTH = 1;
    
    public static testMethod void testSubscriptions() {
        // Settings related to calculating membership flags.
        Ocdla_Apps__c  settings;
        
        // Our sample membership expiration year.  Determines 
        Integer currentMembershipExpirationYear;
        
        Boolean rolloverMembershipYear;
        
        Date newSubEndDate;
        
        Date oldSubEndDate;
        
        rolloverMembershipYear = System.today() >= Date.newInstance(System.today().year(), MEMBERSHIP_EXPIRATION_MONTH, MEMBERSHIP_EXPIRATION_DAY);
        
       	currentMembershipExpirationYear = rolloverMembershipYear ? System.today().year()+1 : System.today().year();
        
        settings = new Ocdla_Apps__c ();
        settings.Ocdla_Current_Membership_Term_End_Date__c  = Date.newInstance(currentMembershipExpirationYear, MEMBERSHIP_EXPIRATION_MONTH, MEMBERSHIP_EXPIRATION_DAY);
        insert settings;
        
		oldSubEndDate = settings.Ocdla_Current_Membership_Term_End_Date__c;
        newSubEndDate = oldSubEndDate.addMonths(MEMBERSHIP_EXPIRATION_ADD_ONE_MONTH);
        
        
        // Insert a new Subscription Plan
        // 
        // Insert a new Subscription Item
        // 
        // Insert a test Contact
        // 
        // Insert a new Subscription
        // 
        OrderApi__Subscription_Plan__c mockSubPlan = new OrderApi__Subscription_Plan__c(Name='Mock Calendar Subscription Plan',
                                                                                        OrderApi__Is_Active__c =True,
                                                                                        OrderApi__Bill_Cycle__c ='AUTO',
                                                                                        OrderApi__Type__c ='Calendar',
                                                                                        OrderApi__Calendar_End_Day__c ='30',
                                                                                        OrderApi__Calendar_End_Month__c ='06');
        insert mockSubPlan;
        
        OrderApi__Item_Class__c mockItemClass = new OrderApi__Item_Class__c(
            Name='Membership: Mock Regular Membership',
            OrderApi__Is_Active__c = True,
            OrderApi__Is_Subscription__c = True // business group??
        );
        insert mockItemClass;
        
        
        OrderApi__Item__c mockSubItem = new OrderApi__Item__c(Name='Mock Subscription Item',
                                                              OrderApi__Price__c=200.00,
                                                              OrderApi__Item_Class__c=mockItemClass.Id,
                                                              OrderApi__Is_Subscription__c=True,
                                                              Ocdla_Subscription_Membership_Status__c='MK');
        insert mockSubItem;
        
        // Item Subscriptioni Plan
        OrderApi__Item_Subscription_Plan__c mockItemSubPlan = new OrderApi__Item_Subscription_Plan__c(OrderApi__Is_Default__c =True,
                                                                                                      OrderApi__Item__c = mockSubItem.Id,
                                                                                                      OrderApi__Subscription_Plan__c =mockSubPlan.Id);
        insert mockItemSubPlan;
        
        
        Account testAccount = new Account(Name='Mock Unit Test Account');
        insert testAccount;
        
        Contact[] contactsToCreate = new Contact[]{};
            for(Integer x=0; x<OcdlaSubscriptionTest.TestBatchSize;x++){
                Contact ct = new Contact(Account=testAccount,FirstName='Mock',LastName='Tester');
                contactsToCreate.add(ct);
            }
        
        //Now insert data causing an contact trigger to fire. 
        // Test.startTest();
        insert contactsToCreate;
        // Test.stopTest();	
        
        
        
        Set<Id> newContactIds = (new Map<Id,Contact>(contactsToCreate)).keyset();
        
        OrderApi__Subscription__c[] subsToCreate = new OrderApi__Subscription__c[]{};
            

            for(Id cId :newContactIds){
                OrderApi__Subscription__c mockSub1 = new OrderApi__Subscription__c(OrderApi__Contact__c=cId,
                                                                                   OrderApi__Item__c=mockSubItem.Id,
                                                                                   OrderApi__Subscription_Plan__c=mockSubPlan.Id,
                                                                                   OrderApi__Current_Term_End_Date__c=newSubEndDate);
                OrderApi__Subscription__c mockSub2 = new OrderApi__Subscription__c(OrderApi__Contact__c=cId,
                                                                                   OrderApi__Item__c=mockSubItem.Id,
                                                                                   OrderApi__Subscription_Plan__c=mockSubPlan.Id,
                                                                                   OrderApi__Current_Term_End_Date__c=oldSubEndDate);
                subsToCreate.add(mockSub1);
                subsToCreate.add(mockSub2);
            }
        
        insert subsToCreate;
        
        
        List<Contact> updatedContacts = [SELECT Id,Ocdla_Current_Member_Flag__c,Ocdla_Member_Status__c,Ocdla_Membership_Expiration_Date__c FROM Contact WHERE Id IN :newContactIds];
        // for(Contact c :updatedContacts){
            // The member's expiration should correspond to the future-most end date.
            // System.assertEquals(newSubEndDate,c.Ocdla_Membership_Expiration_Date__c);
            // System.assert(c.Ocdla_Current_Member_Flag__c);
            // System.assertEquals(c.Ocdla_Member_Status__c,'MK');
        // }
        
    }
}