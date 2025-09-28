global class OcdlaApplicationSettings {
    

    List<String> queryFields = new List<String>{'Id', 'AccountId', 'AuthorizeDotNetCustomerProfileId__c',
        'Name', 'FirstName', 'LastName', 'Email', 'MailingStreet',
        'MailingCity', 'MailingStateCode', 'MailingPostalCode'}; 

	String[] orderSelectFields = new String[]{
        
        'Id','Name','OrderNumber','Status','Description','OpportunityId',
        
		'EffectiveDate','TotalAmount',
            
        'AccountId','Account.Name',
        
        'Origin__c','PostingEntity__c','Payment_Info__c',
      
        'ActivatedDate','ActivatedBy.Id','ActivatedBy.Name','ActivatedBy.Email','ActivatedBy.Username',
        'CreatedDate','CreatedBy.Id','CreatedBy.Name','CreatedBy.Email','CreatedBy.Username',
        
        'BillingStreet','BillingCity','BillingStateCode','BillingPostalCode','BillingCountryCode',
        'ShippingStreet','ShippingCity','ShippingState','ShippingPostalCode','ShippingCountryCode',
        
        'BillToContactId','BillToContact.FirstName','BillToContact.LastName','BillToContact.Email',
        'BillToContact.MailingStreet','BillToContact.MailingCity','BillToContact.MailingStateCode','BillToContact.MailingPostalCode',
        'BillToContact.MailingCountryCode',
        
        'BillToContact.AuthorizeDotNetCustomerProfileId__c',
        
        'Account.ShippingStreet','Account.ShippingCity','Account.ShippingStateCode','Account.ShippingPostalCode','Account.ShippingCountryCode'
    };
        
        String[] orderItemSelectFields = new String[]{
            'Id','LastModifiedDate','LastModifiedBy.Name','LastModifiedBy.Email',
            'CreatedDate','CreatedBy.Name','CreatedBy.Email','ClickpdxOrder__Cid__c',
            'OrderId','OrderItemNumber',
            'Product2Id','Product2.Name',
            'PricebookEntry.Id','PricebookEntry.UnitPrice','Product2.ProductCode',
            'Description','ListPrice',            
            'Quantity','UnitPrice','TotalPrice'};

                
    public Map<String,Object> orderEntry = new Map<String,Object>{
        //'orderSaveableClass' => 'ClickpdxOrder.OrderEntryController.DefaultOrderSave'
        //'orderSaveableClass' => 'ClickpdxOrder.OrgCustomOrderEntrySave'
        // 'remoteObjectPageTemplate' => 'RemoteObjectTemplateOrder'
        'billToContactQueryFields' => queryFields,
        'orderSelectFields' => orderSelectFields,
        'orderItemSelectFields' => orderItemSelectFields
    };
          
 

                
                

    Map<String,Object> productModule = new Map<String,Object>{
        'remotingProxyObject'=>'ClickpdxOrder.OrderEntryController',
            'remoteForceTemplateCalloutImplementation' => null,
            'remoteObjectPageTemplate' => 'RemoteObjectTemplateOrder',
            'moduleActionsClass' => '.OcdlaCustomStoreProductActions',
            'pageTemplate' => '.ClickpdxPageTemplateOneColumn',
            // 'componentManager' => 'ClickpdxStore.DefaultComponentManager',
            //'componentManager' => '.OcdlaStoreComponentManager',
            //  'useComponentNullNamespace' => False,
            'pageSettings' => new Map<String,Object>{'showHeader'=>False,
                'applyHtmlTag'=>False,'applyBodyTag'=>False,'standardStylesheets'=>False}
    };
                    
    /*
        public Map<String,String> orderEntry = new Map<String,String>{'remotingProxyObject'=>'OrderEntryController',
            'remoteForceTemplateCalloutImplementation'=>'c.OrgOcdlaHttpSendable'};
    */
                    
                    
    public Map<String,String> serviceLibrary = new Map<String,String>{
        'app.HtmlFormFieldRenderer'	=>	'DefaultHtmlFormFieldRenderer'
        // 'app.registration.fieldSets' => 'Contact.Fdli_Registration'
    };
                                
                                
    public Map<String,String> pages = new Map<String,String>{
        // 'app.registration'	=> 'FdliPageTemplateOneColumn'
    }; 
                                    
    public String GUEST_CHECKOUT_ACCOUNT_NAME = 'Guest Checkout';
    
    public String CHECKOUT_PAGE = null; // Should be a PageReference
    
    public String COMMUNITY_NAME = 'OCDLA Member Community';
    
    public String STANDARD_PRICE_BOOK_DISPLAY_NAME = 'Members';
    
    public Id DEFAULT_ACCOUNT_OWNER_ID = '00541000002FDTD';
    
    public String COMMUNITY_PROFILE_NAME = 'OCDLA Member Community Profile';
    
    public String loginUrl = null;//'/login';
    
    public String logoutUrl = null;
    
    public String profileUrl = null;
    
    public Boolean REGISTRATION_FORM_IS_TEST = True;
    
    public String DEFAULT_TEST_MODE_USER_EMAIL = 'jbernal.web.dev@gmail.com';
    
    public String DEFAULT_TEST_MODE_CONTACT_EMAIL = 'jbernal.web.dev@gmail.com';
    
    // Any additional Contact fields that will be returned upon the "Account Lookup" button.
    public String REGISTRATION_ADDITIONAL_CONTACT_FIELDS = 'AccountId,MailingStreet,MailingCity,MailingState';
    
    // For now, we are running all requests to Authorize.net through scripts on the member test page.
    public String AUTH_NET_PROXY_SERVER = 'membertest.ocdla.org';
    
    // Name of Apex class used for Http Callout; remember the endpoint needs to be added in your Org's security settings.
    public String REGISTRATION_EXTERNAL_CALLOUT_CLASS_NAME = 'FdliRegistrationBriefCallout';
    
    public OcdlaApplicationSettings(){
        
        COMMUNITY_PROFILE_NAME = 'OCDLA Member Community Profile';
        
    }
    
}