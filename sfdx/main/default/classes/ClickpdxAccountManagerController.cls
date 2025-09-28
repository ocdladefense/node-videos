public virtual without sharing class ClickpdxAccountManagerController {
	
    private String selectedContactId {get; private set;}
    
    public String memidurl           {get; set;}
    
    public Pagereference anotherp = null;
    
    public Boolean disablePage                                { get; set; }
    
    public boolean isEligible        { get; set; }
    
    public Boolean hasLogo        { get; set; }
    
    public Boolean MembershipActive  { get; set; }
    
    public String LogoImageId     { get; set; }
    
    public Boolean AccountInserted = false;
    
    public string billingContry        {get; set;}
    
    public string billingState          {get; set;}
    
    private boolean accounthasActiveMem;
    
    public Map<STring,List<String>> ObjectFieldsetsMap  { get; set; }
    
    public static final Map<String,schema.sObjectType> OBJDESCRIBE = schema.getGlobalDescribe();
    
    public String primaryColor    { get; set; }
    
    //  public String email { get; set; }
    
    /* Controls what we show end users when we have system identified errors (Not field validation everything else) */
    
    public Boolean showError                                    { get; set; }
    
    public String errorMessage                                  { get; set; }
    
    public String debugMessage                             { get; set; }      
    
    public Boolean companyInfo        { get; set; }
    
    public String Benefits {get; set;}
    
    public String selectedMemType {get; set;}
    
    public String selectedSubCategory {get; set;}
    
    public List<String> membershipIds                      { get; set; }
    
    public String membershipIdString;
    
    public integer selectedBenefits                { get; set; }
    
    public Boolean contactInfo { get; set; }
    
    public List<Schema.FieldSetMember> accountFieldList    { get; set; }
    
    public Account acct  { get; set; }
    
    public Account newAcc             { get; set; }
    
    public string selectedAccountId   { get; set; }
    
    public List< selectOption >  accList  {   get;    set;}
    
    public boolean existingComp {get;set;}
    
    public boolean showNewAccount{get;set;}
    
    public boolean createDupe {get; set;}
    
    public boolean compNotFound {get; set;}
    
    public boolean multipleAccFound {get; set;}
    
    public boolean selectedcountry {get; set;}
    
    public Boolean isComplimentary                          { get; set; }
    
    // This is the field set we use for contact
    public List<Schema.FieldSetMember> contactFieldList    { get; set; }
    
    // This is the object we use for the contact
    public Contact con                                     { get; set;}
    
    public List<Contact> conlist {get;set;}
    
    
    // Being "new" members
	protected String nextPage;
	
	protected PageReference redirect;

	public String SubmitButtonText;
	
	public Map<String, String> theParameters;
	
	public static final Boolean ACCOUNT_ALWAYS_RESET_PRIMARY_CONTACT = false;

	public static final Boolean ACCOUNT_SAVE_UPDATED_ACCOUNTS = true;
	
	public static final Boolean ACCOUNT_SAVE_EXISTING_ACCOUNT_NEW_CONTACTS = true;

	public Decimal numLocations {get;set;}
    
    
    
    
    
    /**
     * newer members*/
	static final Boolean APP_USES_LEGACY_MEMBERSHIP_IDS = true;
    
	static final Boolean VIEW_SHOW_ALL_SECTIONS = false;

	static final Id TEST_ITEM_ID = 'a370B00000Hc6ej';
	
	static final Boolean SHOW_SALES_ORDER_EMAIL_FIELD = false;
	
	static final Boolean SHOW_NEW_CONTACT_FORM_FOR_EXISTING_ACCOUNTS = true;
    
    static final Boolean SHOW_CONTACT_FORM_ALWAYS = true;
    
    static final Boolean SHOW_ACCOUNT_FORMS = false;
	
	/**
	 * @static (option)
	 *
	 * @description
	 * 	Whether to change the options displayed for the Primary Segment based
	 *		on that selected for the Account Type.
	 *
	 */
	static final Boolean SHOW_CHANGE_PICKLIST_FOR_PRIMARY_SEGMENT = true;

	static final Integer MAX_NUMBER_SEARCH_RESULTS = 30;
	
	static final Integer EXISTING_ACCOUNT_FOUND = 2;
	
	static final Integer EXISTING_ACCOUNT_NOT_FOUND = 3;
	
	static final Integer ACCOUNT_UNKNOWN = 5;	

	static final Integer NEW_ACCOUNT_PENDING = 4;
	
	static final Integer NEW_ACCOUNT_CREATED = 6;
	
    // Instance variables.
	public String salesOrderEmail {get;set;}

	public Boolean showPrimaryContactPanel;
  	
    public Integer accountStatus;
  
    protected List<OrderApi__Sales_Order_Line__c> oliList;
	
	protected OrderApi__Sales_Order__c o;
	
	public String acctType {get;set;}

	public List<Account> accountSearchResults;
	
    public String searchString {get;set;}
	
	public Integer numAccountsFound {get;set;}
    
    public Boolean uiInitialized {get;set;}    
    // end newer members

    private static String AccQuery;
    
    private static String ContactQuery;
    
    private Id selectedItemId;
    
    private OrderApi__Item__c selectedItem;
    
    public OrderApi__Item__c getSelectedItem(){
        return this.selectedItem;
    }
    
    // Constructor
    public ClickpdxAccountManagerController() {
        
        Map<String,String> theParameters = ApexPages.currentPage().getParameters();
        
		selectedAccountId = theParameters.get('accountId');
        
        selectedContactId = theParameters.get('contactId');
        
        selectedItemId = theParameters.get('itemId');
        
        selectedItem = null != selectedItemId ? [SELECT Id, Name, OrderApi__Price__c FROM OrderApi__Item__c WHERE Id = :selectedItemId] : null;
        
        // AccQuery = constructQuery('Account');
        
        // ContactQuery = 'SELECT Id, Name, FirstName, LastName, MiddleName, MailingStreet, MailingStateCode, MailingPostalCode FROM Contact';
        // ContactQuery = 'SELECT Id, Name, FirstName, LastName FROM Contact';
        // ContactQuery += ' WHERE Id = \''+ selectedContactId +'\' LIMIT 1';
		// ContactQuery = constructQuery('Contact') + ' WHERE Id = \''+ selectedContactId +'\' LIMIT 1';
        
        try {

        
        accounthasActiveMem = false;
        
        selectedBenefits = 0;
        
        Benefits  = '0';
        
        selectedMemType = 'Organization';
        
        selectedcountry = false;
        
        List<String> accountFieldsets = new List<String>();
        
        ObjectFieldsetsMap = new Map<String,List<String>>();
        
        ObjectFieldsetsMap.put('Account',accountFieldsets);
        
        membershipIds = new List<String>();


        
		con = theParameters.get('contactId') == null ? null : [SELECT Id, AccountId, Name, FirstName, Suffix, Salutation, LastName, MiddleName, Ocdla_Address_Line_1__c, Ocdla_Address_Line_2__c, OrderApi__Work_Email__c, MailingCity, MailingStateCode, MailingCountryCode, MailingPostalCode, Email, Fax, OrderApi__Work_Phone__c FROM Contact WHERE Id = :selectedContactId];
        con = con == null ? new Contact(Id=null,AccountId=null) : con.clone(False,True,True,True);
        // con = new Contact(Email = 'jbenal.web.dev@gmail.com');  
            
        acct = new Account();
        
        newAcc = new Account();
        
        conlist = new List<Contact>();
        
        createDupe = false;
        
        existingComp = false;
        
        showNewAccount = false;
        
        compNotFound = false;
        
        contactInfo = false;
        
        companyInfo = false;
        
        showError = false;
        
        errorMessage = '';
        
        debugMessage = '';
        
        isComplimentary = false;

		// calls private method that gets the primary color and logo from the configuration object
        setupBranding(); 


        
        companyInfo = true;//@jbernal
        
		salesOrderEmail = '';
            
        // new construtor, migrated
		SubmitButtonText = 'Next';

        // newer constructor, migrated
		showPrimaryContactPanel = false;
        
		// Check if an accId has been appended to the URL
		accountStatus = ACCOUNT_UNKNOWN;
            
        } catch(Exception e){
            showError = True;
            errorMessage = e.getMessage();
        }
    }

	/**
	 * 
	 * @method ConfirmProducts
	 *
	 * @description 
	 * 		Save, in this order:
	 *			 - The Account
	 *				- The Contact
	 *  Advance the user to a confirmation page; otherwise remain on the current page
	 *	and show any relevant errors.
	 *
	**/
    public pageReference ConfirmProducts() { 
		// Flag to set whether any errors are encountered during processing.
        Boolean hasError = False;
        
        // Let's backup our database and rollback if we have any errors
        Savepoint sp;
        
        // Various redirects, depending on whether there are errors and such.
        PageReference errorNoRedirect = Page.OcdlaAccountManager;
        errorNoRedirect.setRedirect(True);
        
        // Deprecated reference to a previous "Confirmation" page.
        PageReference confirmationRedirect = null;
        
        // The next step, if everything is successful.
        PageReference step2 = Page.OcdlaAccountManager;//theParameters.get('retUrl') == null ? Page.OcdlaAccountManager : Page.ClickpdxProductApp;
        step2.setRedirect(True);
        
        // References either the new or existing Account associated with this workflow.
        Account theAccount;
        
        // References the Contact data submitted by the customer.
        Contact theContact;
        
        // Reference to the saved User wrapper object
        ClickpdxUser u;
        
        // Reference any created Users
        User theUser;
        
        
        try {
            sp = Database.setSavepoint(); 
            // Save the Contact provided by the User
            selectedContactId = selectedContactId != null ? selectedContactId : getExistingContactId(con.Email);
            
            if(null != selectedContactId){
            	Contact validate = [SELECT Id, AccountId FROM Contact WHERE Id = :selectedContactId];
                if(null == validate.AccountId) throw new ClickpdxAppException('Account Id is still null!');
                con.AccountId = validate.AccountId;
            }
			
            
            if(True || ACCOUNT_SAVE_EXISTING_ACCOUNT_NEW_CONTACTS || this.getIsNewAccount()) {
                theContact = this.SaveContact(con, selectedContactId);
            }
            
            // theContact.AccountId = [SELECT AccountId FROM Contact WHERE Id = :theContact.Id].AccountId;
            // update theContact;
           
            // Validate that any saved Contact has an AccountId.
        //if(null == theContact.AccountId) throw new ClickpdxAppException('Created contact does not have an AccountId.');
            
            
            // Move on to product selection
            step2.getParameters().put('contactId', theContact.Id);
            errorNoRedirect.getParameters().put('contactId', theContact.Id); 
        }
        catch(Exception e)
        {
            hasError = True;
            Database.rollback(sp);
            errorNoRedirect.getParameters().put('itemId', this.selectedItemId); 
            errorNoRedirect.getParameters().put('error', 'true');
            errorNoRedirect.getParameters().put('message', e.getMessage());
            errorNoRedirect.getParameters().put('stack', e.getStackTraceString());
            return errorNoRedirect;
        }
        
        try {
			PageReference checkout = ClickpdxMembershipSalesOrder.Checkout(theContact, selectedItemId);
            return checkout;
        } catch(Exception e) {
            hasError = True;
            Database.rollback(sp);
            errorNoRedirect.getParameters().put('contactId', theContact.Id); 
            errorNoRedirect.getParameters().put('itemId', this.selectedItemId); 
            this.errorMessage = e.getMessage();
            errorNoRedirect.getParameters().put('error',e.getMessage());
            return errorNoRedirect;
        }
        /*
        // Attempt to create a new User.
        // If there was an error at any previous point then bail out.
        try {
            sp = Database.setSavepoint(); 
            if(!hasError){
                u = new ClickpdxUser(theContact);
                if(!u.userExists()){
                    theUser = u.save();
                }
                return step2; 
            } else {
                return errorNoRedirect;
            }
        } catch(Exception e){
            hasError = True;
            Database.rollback(sp);
            errorNoRedirect.getParameters().put('contactId', theContact.Id);
            errorNoRedirect.getParameters().put('error', 'true');
            errorNoRedirect.getParameters().put('message', ('Nickname '+u.nickname+ ' '+e.getMessage()));
            errorNoRedirect.getParameters().put('stack', e.getStackTraceString());
            return errorNoRedirect;
        }
*/
    }
    
    
    public static Id getExistingContactId(String email) {
        List<Contact> cExisting = null;
        
        if(!String.isEmpty(email)) {
            cExisting = [SELECT Id FROM Contact WHERE email=:email LIMIT 1];
        }
        
        return (null != cExisting && cExisting.size() > 0 ? cExisting[0].Id : null);
    }
    
	public virtual Contact SaveContact(Contact theContact, Id targetContactId) {
		
        Contact forSave;
        Id AccountId;
        Account theAccount;
        
        AccountId = theContact.AccountId;
        

        forSave = theContact.clone();
        forSave.Id = targetContactId;
        forSave.MailingCountryCode = 'US';
        
        // Create a new Account, if necessary.
        if(null == AccountId){
            String AccountName = theContact.FirstName + theContact.LastName;
            theAccount = new Account(Name=AccountName);
            theAccount.OwnerId = '005j000000DDkk7';
            insert theAccount;
        }
        
		forSave.AccountId = null == theContact.AccountId ? theAccount.Id : theContact.AccountId;
		upsert forSave;
	
        
        return forSave;
	}
    
    public Boolean getShowContactFormAlways(){
        return SHOW_CONTACT_FORM_ALWAYS;
    }
    
    public Boolean getShowAccountForms(){
        return SHOW_ACCOUNT_FORMS;
    }
    
    public Boolean getShowContactFieldSet(){
        
        return (null != contactFieldList && contactFieldList.size() > 0);
        
    }
    
    public virtual Boolean getShowAccountFieldSet() {
        return (null != accountFieldList && accountFieldList.size() > 0);
    }
    
    public List<SelectOption> getcontry(){
		List<SelectOption> options;
        Set<String> billingcontrys;
        List<Account> accounts;
        
        options = new List<SelectOption>();
        billingcontrys = new Set<String>();
        accounts = [SELECT BillingCountry, Name,BillingState FROM 
                                 Account WHERE parent.Id = null AND BillingCountry != null AND 
                                 BillingState != null ORDER BY BillingCountry ASC];
        
        options.add(new SelectOption('','-Select-'));
        
        for( Account a:accounts){
            if(a.BillingCountry !=null && a.BillingCountry != 'United States'){
                billingcontrys.add(a.BillingCountry);
            }
            // billingcontrys.sort();
        }
        
        for(String b :billingcontrys){
            if(b != 'United States'){
                options.add(new SelectOption(b,b));
            }
        }
        
        options.sort();
        options.add(0, new SelectOption('United States','United States'));
        
        return options;
    }

    
    
    public List<SelectOption> getstate(){
        List<SelectOption> options = new List<SelectOption>();
        Set<String> billingstates = new Set<String>();
        
        /*
        List<Account> accounts= [SELECT BillingState,name FROM Account 
                                 WHERE parent.id=null AND BillingCountry=:billingContry AND 
                                 BillingState!=null AND BillingCountry!=null 
                                 ORDER BY BillingCountry DESC LIMIT 40000];
        */
        
        options.Add(new SelectOption('','-Select-'));
        
        /*
        for( Account a:accounts){
            // if(a.BillingState!=null)
            // billingstates.add(a.BillingState);
            // billingstates.sort();
        }
		*/
        
        for(String s:billingstates){
            options.add(new selectoption(s,s));
        }
         
        options.sort();
        
        return options;
    }
    


 
    
    public PageReference tempMethod(){
        selectedAccountId = '';
        return null;
    }
    

    
    public string selectedSubCategory()
    {
        selectedSubCategory = ApexPages.currentPage().getParameters().get('subcategory');
        return selectedSubCategory;
    }
    
    
    // gets the primary color and logo from the configuration object
    private void setupBranding(){
        try { // this could throw exceptions if configuration object has no logo or primary color let's keep it inside a try/catch block
            LogoImageId = 'foobar';//[SELECT MN4__Portal_Logo__c FROM MN4__Configuration__c WHERE Name = 'DEFAULT'].MN4__Portal_Logo__c;
            primaryColor = 'red';//[SELECT MN4__Portal_Primary_Color__c FROM MN4__Configuration__c WHERE Name = 'DEFAULT'].MN4__Portal_Primary_Color__c;
            
            hasLogo = LogoImageId != Null ? true : false;            
        } catch (Exception ex) {
            showError = true;
            errorMessage = 'You need to have a logo and a color setup to make this form look pretty!';
            hasLogo = false;
        }
        
    }


    

    

    

	
	/**
	 * 
	 * @method SaveContact
	 *
	 * @description
	 *
	 * 		Save the given Contact.
	 *		If the Contact already exists then update the existing Contact; 
	 *		otherwise, insert the new Contact.
	 *
	 * @params
	 *		- Account a - An Account that the Contact should be associated with.
	 *		- Contact c - The Contact whose information should be used to either update
	 *				an existing Contact or to insert a new Contact.
	 *
	 *****/

    

    /*
    public pageReference ConfirmProducts() { 
		// Flag to set whether any errors are encountered during processing.
        Boolean hasError = False;
        
        // Let's backup our database and rollback if we have any errors
        Savepoint sp;
        
        // Various redirects, depending on whether there are errors and such.
        PageReference errorNoRedirect = Page.OcdlaAccountManager;
        errorNoRedirect.setRedirect(True);
        
        // Deprecated reference to a previous "Confirmation" page.
        PageReference confirmationRedirect = null;
        
        // The next step, if everything is successful.
        PageReference step2 = Page.ClickpdxProductApp;
        step2.setRedirect(True);
        
        // References either the new or existing Account associated with this workflow.
        Account theAccount;
        
        // References the Contact data submitted by the customer.
        Contact theContact;
        
        // Reference to the saved User wrapper object
        ClickpdxUser u;
        
        // Reference any created Users
        User theUser;
        
        
        try
        {
            sp = Database.setSavepoint(); 
            
            // throw new MemberAppException('selected account is: '+selectedAccountId);
            // Only save Account info for new Accounts.
            // Unless the we've specified the corresponding options.
            if(ACCOUNT_SAVE_UPDATED_ACCOUNTS || this.getIsNewAccount()) {
                theAccount = this.SaveAccount();
            }
        }
        catch(Exception e)
        {
            hasError = True;
            Database.rollback(sp);
            errorNoRedirect.getParameters().put('error', 'true');
            errorNoRedirect.getParameters().put('message', e.getMessage());
            errorNoRedirect.getParameters().put('stack', e.getStackTraceString());
            return errorNoRedirect;
        }
        
        try {
            sp = Database.setSavepoint(); 
            // Save the Contact provided by the User
            if(ACCOUNT_SAVE_EXISTING_ACCOUNT_NEW_CONTACTS || this.getIsNewAccount()) {
                theContact = this.SaveContact(theAccount,con);
            }
            
            // For new Accounts, always set the Primary Contact.
            theAccount.OrderApi__Primary_Contact__c = this.getIsNewAccount() ? theContact.Id : theAccount.OrderApi__Primary_Contact__c;
            update theAccount;
            
            // For existing Accounts, only reset the Primary Contact according to the app setting.
            theAccount.OrderApi__Primary_Contact__c = ACCOUNT_ALWAYS_RESET_PRIMARY_CONTACT ? theContact.Id : theAccount.OrderApi__Primary_Contact__c;
            update theAccount;
            
            // Move on to product selection
            step2.getParameters().put('subcategory', 'Operator');
            step2.getParameters().put('accid', theAccount.Id);
            step2.getParameters().put('conid', theContact.Id); 
        }
        catch(Exception e)
        {
            hasError = True;
            Database.rollback(sp);
            errorNoRedirect.getParameters().put('accid', theAccount.Id);
            errorNoRedirect.getParameters().put('error', 'true');
            errorNoRedirect.getParameters().put('message', e.getMessage());
            errorNoRedirect.getParameters().put('stack', e.getStackTraceString());
            return errorNoRedirect;
        }
        
        // Attempt to create a new User.
        // If there was an error at any previous point then bail out.
        try {
            sp = Database.setSavepoint(); 
            if(!hasError){
                u = new ClickpdxUser(theContact);
                if(!u.userExists()){
                    theUser = u.save();
                }
                return step2; 
            } else {
                return errorNoRedirect;
            }
        } catch(Exception e){
            hasError = True;
            Database.rollback(sp);
            errorNoRedirect.getParameters().put('accid', theAccount.Id);
            errorNoRedirect.getParameters().put('conid', theContact.Id);
            errorNoRedirect.getParameters().put('error', 'true');
            errorNoRedirect.getParameters().put('message', ('Nickname '+u.nickname+ ' '+e.getMessage()));
            errorNoRedirect.getParameters().put('stack', e.getStackTraceString());
            return errorNoRedirect;
        }
    }
	*/

	/**
	 * 
	 * @method SaveAccount
	 *
	 * @description
	 *
	 * 		Save an Account - 
	 *		Save either new Accounts or existing Accounts
	 *
	 * @params
	 *		NONE
	 *
	 *****/
	public virtual Account SaveAccount() {
        
        Account updatedAccount = new Account();
		
        showError = false;
		
        String stateCode = acct.BillingStateCode;
		
        String country = acct.BillingCountryCode;
		
        Map<String,String> requiredStateCodes = new Map<String,String>{'UNITED STATES' => 'US','CANADA' => 'CA'};
        
            Boolean requiresStateCode = requiredStateCodes.containsKey(country);
		
        // Just in case, let's set a default value for the Account's subcategory.
        selectedSubCategory = selectedSubCategory == null ? 'Operator' : selectedSubCategory;
        
		if(!this.getIsNewAccount())
		{
            updatedAccount = this.reloadAccount(selectedAccountId);
			updatedAccount.type = selectedSubCategory;
			updatedAccount.BillingStateCode = requiresStateCode ? stateCode : null;
            
			upsert updatedAccount;
			return updatedAccount;
		}

		else
		{
			acct.Type = selectedSubcategory;
			insert acct;
            
			accountInserted = true;

			Account inserted = [SELECT Id, Name, BillingStateCode, BillingCountry, BillingCountryCode FROM Account WHERE Id = :acct.Id];
			inserted.BillingCountryCode = requiresStateCode ? requiredStateCodes.get(country) : getCountryCodeFromLabel(country);
			inserted.BillingStateCode = requiresStateCode ? stateCode : null;
			update inserted;

			return inserted;
		}
	}
	
    // Returns a new Account record under the auspices of the System user.
    // Needed since Anonymous users cannot update records.
    public Account reloadAccount(Id AccountId){
        Account forUpsert;
        
        forUpsert = [SELECT Id, Name FROM Account WHERE Id = :AccountId];
        
        return forUpsert;
    }
    

	
    private String getCountryCodeFromLabel(String label){
        String ret;
		Map<String,String> tmp;
        
        if(null == label) return null;
      /*  
        tmp = new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        // System.debug('Picklist::'+ple);
        for( Schema.PicklistEntry f : ple){
            tmp.put(f.getLabel().toLowerCase(),f.getValue());
        }
        
        try {
            ret = tmp.get(label.toLowerCase());
        } catch(System.NullPointerException e){
            ret = null;
        }
*/
        return ret;

    }
	
    
/*
	protected virtual void logErrorMessage(Exception e, String msg, String debugMsg) {
		showError = true;
		errorMessage = msg;
		debugMessage = debugMsg + e;
		System.debug('Line number: ' + e.getLineNumber());   
		System.debug('Message: ' + e.getMessage());    
		System.debug('Exception type caught: ' + e.getTypeName());    
		System.debug('Stack trace: ' + e.getStackTraceString()); 
	}
*/	
	
	// scriptPanel,submit,membershippanel
	public pageReference tempMethod2() {
		Account a = [SELECT Id, Name, OrderApi__Primary_Contact__c, Type FROM Account WHERE parent.Id = null AND Id =:selectedAccountId];

		if(a.OrderApi__Primary_Contact__c != null) {
			con = [SELECT Name, FirstName, LastName, Phone, Email FROM Contact WHERE Id = :a.OrderApi__Primary_Contact__c];
		}

		MembershipActive = [SELECT Id FROM OrderApi__Subscription__c WHERE OrderApi__Account__c =:selectedAccountId AND OrderApi__Is_Active__c = True].size()>0;

		if(MembershipActive) {
			//showError = true;
			errorMessage = 'Active Membership Exists for this Account!';
			SubmitButtonText = 'Renew Now';
			//   return null;
		}

		return null;
	}	

    	/**
	 * 
	 * @method getFormAccountFieldsDisabled
	 *
	 * @description
	 *		determine whether the Account fields shown on the form should be disabled.
	 *		Disabled form elements should not be returned to the server with data.
	 *		For existing Accounts, we don't wish to update any data when the customer renews or
	 *		establishes a membership.  Such Account updates should be done using a different
	 *		customer interaction.
	 */
	public String getFormAccountFieldsDisabled() {
		return 'BillingStreet,BillingPostalCode,Number_of_Locations__c,BillingCity,State__c,Country__c,Type,MN4_Primary_Segment__c';
		// return (accountStatus == EXISTING_ACCOUNT_FOUND || accountStatus == ACCOUNT_UNKNOWN);
	}
	
	public Boolean getShowSalesOrderEmailFormField() {
		return (!this.getIsNewAccount() && !this.getIsUnknownAccount() && SHOW_SALES_ORDER_EMAIL_FIELD);
	}
	
	public Boolean getUpdatePrimarySegmentPicklist() {
		return SHOW_CHANGE_PICKLIST_FOR_PRIMARY_SEGMENT;
	}
    
    public Boolean getAlwaysShowAllSections(){
        return VIEW_SHOW_ALL_SECTIONS;
    }
	/**
	 * Whether to show the new Contact form for.
	 *
	 */
	public Boolean getShowNewContactFormForExistingAccounts(){
		return SHOW_NEW_CONTACT_FORM_FOR_EXISTING_ACCOUNTS;
	}
	
	public Boolean getIsNewAccount() {
		return (accountStatus == NEW_ACCOUNT_PENDING || accountStatus == NEW_ACCOUNT_CREATED);
	}
	
	public Boolean getShowFoundAccountDetails() {
		return accountStatus == EXISTING_ACCOUNT_FOUND;
	}
	
	public Boolean getIsUnknownAccount() {
		return accountStatus == ACCOUNT_UNKNOWN;
	}
	
	public String getFormPrimaryContactName() {
		return con.Name;
	}
	
	public void passNo() {
		accountStatus = NEW_ACCOUNT_PENDING;
		
        resetFormPrimaryContact();
		
        acct = new Account();
        
		showNewAccount = true;
		
        selectedAccountId = null;
		
        showPrimaryContactPanel = true;
	}
	
	private void resetFormPrimaryContact() {
		con = new Contact();
	}

    public String getSearchString(){
        return this.searchString;
    }
    
    public void setSearchString(String s){
        this.searchString = s;
    }


    public PageReference populateAccount() {
        Account accTemp;
        
        // Set the controller's Account Id.
        selectedAccountId = ApexPages.currentPage().getParameters().get('accid');
        
        
        accTemp = [SELECT Id, Name, OrderApi__Primary_Contact__c, Type FROM Account WHERE parent.Id = null AND Id = :selectedAccountId];
        
        
        try {
            if(accTemp.OrderApi__Primary_Contact__c != null)
            {
                con = [SELECT Name, FirstName, LastName, Phone, Email FROM Contact WHERE Id = :accTemp.OrderApi__Primary_Contact__c];
            }
            else
            {
                // resetFormPrimaryContact();
            }
            
            if(!String.isEmpty(selectedAccountId)) {
                accountStatus = EXISTING_ACCOUNT_FOUND;
                Account tmp = Database.query(AccQuery + ' WHERE Id = \''+ selectedAccountId +'\' ');
                acct = tmp.clone(False,True,True,True);
                existingComp = true;
            } else {
                acct = new Account();    
                existingComp = false;
            }
            return null;
            
        } catch(Exception e){
            return null;
        }
    }
	

	 
	
	public void setSelectedAccount(String accountId){
		selectedAccountId = accountId;
	}
	
	
	
	public String getAccountSearchResults() {
		return JSON.serialize(accountSearchResults);
	}
	
	
	private List<Account> fuzzyAccountSearchByName(String accountName) {
		String accNameToLower;
		String searchName = String.escapeSingleQuotes(accountName.toLowerCase());
		

		List<Account> searchAccounts = new List<Account>();
        
		String searchPart = '\'%'+searchName+'%\'';
 
		searchAccounts = Database.query('SELECT Id,Name,BillingStateCode,BillingCity FROM Account WHERE parent.Id = null AND Name LIKE '+searchPart+' LIMIT '+MAX_NUMBER_SEARCH_RESULTS);
 
		return searchAccounts;
	}
	
    public pageReference VerifyCompany() {
        
        accountStatus = EXISTING_ACCOUNT_NOT_FOUND;
        
		uiInitialized = True;
        
        createDupe = false;
        
        // Reset any previously-selected Account.
        selectedAccountId = null;
        
        existingComp = false;
        
        showNewAccount = false;
        
        compNotFound = true;
        
        multipleAccFound = false;
        
        accountSearchResults = !String.isEmpty(searchString) ? fuzzyAccountSearchByName(searchString) : new List<Account>();
        
        if(!(accountSearchResults.size() > 0)) {
            return null;
        }
        
        numAccountsFound = accountSearchResults.size();
        
        multipleAccFound = accountSearchResults.size() > 1;
        
        compNotFound = false;
        
        return null;
    }



	public Boolean hasCurrentMembership(Account a) {
		return false;
	}



/*
      protected String constructQuery(String objectType) {
        String query = 'SELECT Id, Name ';
        Map<String, Schema.FieldSet> FSMap = OBJDESCRIBE.get(objectType).getDescribe().fieldsets.getMap();

        for ( String Fs : ObjectFieldsetsMap.get( ObjectType ) ) {
            if(null == FSMap.get(fs)) break;
            for ( Schema.FieldSetMember field : FSMap.get(fs).getFields() ) {
                String fieldpath = field.getFieldPath();

                if ( fieldpath != 'Name' )
                    query += ', ' + field.getFieldPath();
            }
        }

        if( objectType == 'Account' )
       		// query += ', BillingAddress ';

        if( objectType == 'Contact' )
            query = 'SELECT Id, Title, Salutation, Name, FirstName, LastName, MiddleName, MailingStreet, MailingStateCode, MailingPostalCode';


        query += ' FROM ' + objectType; 

        return query;
    }
*/	


}