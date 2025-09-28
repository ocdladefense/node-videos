// https://ocdla--ocdpartial.sandbox.my.site.com/services/apexrest/api/media/id/purchase
@RestResource(urlMapping='/api/media/*/purchase')
global without sharing class MediaPurchase {
    
      
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse resp = Restcontext.response;
        
        Map<String,String> headers = req.headers;
        String body = req.requestBody.toString();
        
        
          
        // String messageType = headers.get('x-amz-sns-message-type');
        String[] urlParts = req.requestURI.split('/');
		String resourceId = urlParts[urlParts.size() - 2];
        // Map<String,String> details = (Map<String,String>)JSON.deserialize(body, Map<String,String>.class);
        
        
        // how do we know which customer is submitting this request?
        // Get that customers Id
        // userinfo.getUserId() -info of the curent user
        Id userId = userInfo.getUserId();    //'005VC00000ET8LaYAL'
        
        // Query the ContactId from the User record
        User currentUser = [
            SELECT Id, ContactId
            FROM User
            WHERE Id = :userId
            LIMIT 1
        ];
        
        Id contactId = currentUser.ContactId; //'003VC00000rtzKUYAY'
        
     
        // Get account from contact
        Contact c = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
        
        // Assign productId
        // return productId based on the query for the productId based on the resourceId of the related media record
           
        Media__c media = [
            SELECT Id, Product__c, Event__c
            FROM Media__c
            WHERE resourceId__c = :resourceId
            LIMIT 1
        ];
        
        List<Product2> products = [
            SELECT Id, Name
            FROM Product2
            WHERE Name LIKE '%Audio%'
            AND Event__c = :media.Event__c
        ];
        
        
        Id productId = products[0].id; //'01t0a000004hyc4AAA'; 
        
        
        // Assign pricebookId
        Pricebook2 customPb = [
            SELECT Id 
            FROM Pricebook2 
            WHERE IsStandard = true
            LIMIT 1
        ];
        
        Id pricebookId = customPb.Id; //'01sj0000001pjB9AAI';   // Pricebook2 Id
        
        //Id standardPricebookId = Pricebook2.getStandardPricebookId();
        
        // Proccess credit card
        // 1. construct authroize.net client
        AuthorizeDotNetRequest req2 = new AuthorizeDotNetRequest('createTransaction');
        // 2. construct authorize.net request
        req2.put('cardNumber', '4111111111111111');
        req2.put('amount', 50.00);
        req2.put('expiryMonth', '12');
        req2.put('expiryYear', '2026');
        // 3. pass authorize.net request to client.send
        // Fake Authorize.net JSON payload
        String fakeResponseJson = '{"messages":{"resultCode":"Ok","message":[{"code":"I00001","text":"Transaction approved (simulated)."}]}}';
        
        AuthorizeDotNetResponse res2 = new AuthorizeDotNetResponse(fakeResponseJson);
        res2.deserialize();
        
        if (res2.success()) {
            System.debug('Payment approved: ' + res2.getMessages().getResultCode());
        } else {
            System.debug('Payment failed.');
        }
        // 4. check status of response
        if (res2.success()) {
             resp.statusCode = 200;
        
            // Create an order
            Id standardPricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
        
            Order o = new Order(
                AccountId = c.AccountId, 
                Pricebook2Id = standardPricebookId,
                EffectiveDate = Date.today(),
                Status = 'Draft'
            );
             // 5. insert order if response is good
            insert o;
        } else {
             resp.statusCode = 400;
        }
       
        
      	// Create the Order
        Order newOrder = new Order(
            AccountId = c.AccountId,
            EffectiveDate = Date.today(),
            Status = 'Draft' ,
            ContractId = null,
            Pricebook2Id  = '01sj0000001pjB9AAI' 
        );
        insert newOrder;
      	
        // Retrieve correct pricebookEntry, used to get PricebookEntryId
        List<PricebookEntry> entries = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Product2Id = :productId
              AND Pricebook2Id = :pricebookId
              AND IsActive = true
            LIMIT 1
        ];        
        
        PricebookEntry pbe = entries[0];
        
        // Insert products into OrderItem
        // Product 1
        OrderItem oi1 = new OrderItem(
            OrderId = newOrder.Id,
            Product2Id = productId,
            PricebookEntryId = pbe.Id, 
            Quantity = 2,
            UnitPrice = 100
        );

        // Insert the OrderItem
        insert new List<OrderItem>{ oi1 };
        
        // For now just return a success "mock purchase"
        Map<String,Object> mockPurchase = new Map<String,Object>{
            'contactId'  => contactId,
            'resourceId' => resourceId,
            'status'     => 'purchased'
        };

        resp.statusCode = 200;
        resp.responseBody = Blob.valueOf(JSON.serialize(mockPurchase));
        
         // If the card goes through, the response will return true.
        //if (cardSuccess) {
           // resp.statusCode = 200;
     
        // If they are declined, return 403, false
        //} else {
           // resp.statusCode = 403;
            
        //}            
     
    }
    
}