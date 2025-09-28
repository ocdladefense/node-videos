/**
 * @class OcdlaAccountMembershipRenewal 
 * 
 * @author José Bernal
 * 
 * @used on Button on Account detail pages.
 * 
 * @description Account membership renewals.  Populate an Opportunity object with an Opportunity Product 
 * for each Contact on the Account.  The Opportunity Product should correspond to the appropriate membership
 * product for that Contact, e.g., a Professional member should be sold the OCDLA Professional Membership.
 */

global class OcdlaAccountMembershipRenewal {

    private static ClickpdxPricebookEntryManager manager;
    
    private static final String MEMBER_STATUS_JUDICIAL = 'X';
    
    private static final String MEMBER_STATUS_COMPLIMENTARY = 'C';
    
    private static final String MEMBER_STATUS_LIFETIME = 'L';
    
    private static final String MEMBER_STATUS_LAW_LIBRARY = 'LL'; 
    
    private static final String MEMBER_STATUS_REGULAR = 'R';
    
    private static final String MEMBER_STATUS_STAFF = 'T';
    
    private static final String MEMBER_STATUS_OFFICE_ADMIN = 'ADMIN';
    
    private static Set<String> INVALID_RENEWAL_STATUSES = new Set<String>{
        MEMBER_STATUS_OFFICE_ADMIN,MEMBER_STATUS_JUDICIAL,MEMBER_STATUS_COMPLIMENTARY,MEMBER_STATUS_LIFETIME,MEMBER_STATUS_LAW_LIBRARY
    };

	public static final Date MEMBERSHIP_RENEWAL_DATE = Date.newInstance(2026,6,30);
    
    private static final Integer BAR_YEAR_FLOOR_NEW_BAR = 2025;
    
    private static final Integer BAR_YEAR_FLOOR_RECENT_BAR = 2021;
    
    public static final String PAID_OFFICE_MEMBERSHIP_OPPORTUNITY_NAME = 'Paid Office Membership Renewal';
    
    @TestVisible
   	// Available membership products that can be assigned to the pending cart.
    private static Map<String,List<PricebookEntry>> membershipEntries;

    
    @TestVisible
    // Retrieve catalog of membership products assigned the Memberships family.
	private static final String MEMBERSHIP_PRODUCT_FAMILY = 'Memberships';
    
    
    // This is the Name assigned to the Opportunity record.  Distinguished from
    // OCDLA Shopping Cart Opportunities.
	private static final String PAID_OFFICE_RENEWAL_OPPORTUNITY_NAME = 'Paid Office Membership Renewal';
    
    

    
    
    webservice static Opportunity createAccountMembershipRenewal(Id accountId){
        
        Account a = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        
        ClickpdxShoppingCart pdCart;
        
        Opportunity cartOpportunity;
        
        List<ClickpdxCartItem> items = new List<ClickpdxCartItem>();
        
        List<Contact> contacts = new List<Contact>();
        
        // @jbernal, use dynamic query syntax.
        // @todo - Remove reference to OrderApi__Primary_Contact__c.
		Account theAccount = Database.query('SELECT Id, Name, OrderApi__Primary_Contact__c FROM Account WHERE Id = :accountId');
        
        
        initMembershipEntries();
        
        
        contacts = [SELECT Id, FirstName, LastName, Email, Ocdla_Member_Status__c, Ocdla_Membership_Expiration_Date__c,
                    Ocdla_Bar_Number__c, Ocdla_Investigator_License_Number__c, Ocdla_Bar_Year__c
                    FROM Contact WHERE AccountId = :accountId AND Ocdla_Current_Member_Flag__c = True];
        
        // Configure the shopping cart object and underlying Opportunity.
        // I believe this effectively grabs the user's current shopping cart (if any)
        // And converts it to a Paid Office cart (hence the upsert, below).
        pdCart = new ClickpdxShoppingCart(a, PAID_OFFICE_MEMBERSHIP_OPPORTUNITY_NAME);  
        cartOpportunity = pdCart.getOpportunity();
        cartOpportunity.Name = PAID_OFFICE_MEMBERSHIP_OPPORTUNITY_NAME;
        cartOpportunity.Contact__c = (Id)theAccount.get('OrderApi__Primary_Contact__c');
        upsert cartOpportunity;
        
        pdCart = new ClickpdxShoppingCart(cartOpportunity.Id);
        
        // Loop through all of the Contacts for the Account
        // and to start with add a regular membership
        // pdCart.addItem(entry,c)
        
        for(Contact c: contacts){
            if(null == c.Ocdla_Member_Status__c || INVALID_RENEWAL_STATUSES.contains(c.Ocdla_Member_Status__c)){
                // Skip Lifetime members, law libraries, and others.
                continue;
            }
            
            String license = c.Ocdla_Member_Status__c == 'N' ? c.Ocdla_Investigator_License_Number__c : c.Ocdla_Bar_Number__c;
            // If the members has already renewed
            // then assign them the "Already Renewed" product.
            // Otherwise, choose the most appropriate membership product for their renewal.
            PricebookEntry tmp = c.Ocdla_Membership_Expiration_Date__c == OcdlaAccountMembershipRenewal.MEMBERSHIP_RENEWAL_DATE ? lookupAlreadyRenewed() : lookupMembershipProduct(c.Ocdla_Member_Status__c,(Integer)c.Ocdla_Bar_Year__c);
            PricebookEntry real = manager.entry(tmp.Id);
            
            ClickpdxCartItem item = new ClickpdxCartItem(real);
            item.license = license;
            item.contactId = c.Id;
            item.firstName = c.FirstName;
            item.lastName = c.LastName;
            item.email = c.Email;
            items.add(item);
        }
        
        ClickpdxCartItem.saveAll(pdCart,items);
        
        return cartOpportunity;
    }

    
    



    @TestVisible
    private static void initMembershipEntries(){
        List<PricebookEntry> entries;
        membershipEntries = new Map<String,List<PricebookEntry>>();
        
        entries = [SELECT Id, UnitPrice, Product2.Description, Product2.ClickpdxCatalog__LineDescription__c, Product2.Id, Product2.Name, Product2.OcdlaMembershipStatusGrant__c,
                   Product2.OcdlaMinimumBarYearEligibility__c FROM PricebookEntry WHERE IsActive = True AND Product2.Family = :MEMBERSHIP_PRODUCT_FAMILY
                  AND Product2.OcdlaMembershipStatusGrant__c != NULL ORDER BY Product2.OcdlaMembershipStatusGrant__c ASC,
                   Product2.OcdlaMinimumBarYearEligibility__c DESC];
        
        manager = new ClickpdxPricebookEntryManager(entries);
        
        
        if(null == entries || entries.size() < 1){
            throw new OcdlaInvalidMembershipStatusException('No memberships found.');
        }
        
        for(PricebookEntry e: entries){
            if(null == membershipEntries.get(e.Product2.OcdlaMembershipStatusGrant__c)){
                membershipEntries.put(e.Product2.OcdlaMembershipStatusGrant__c,new List<PricebookEntry>{e});
            } else {
				membershipEntries.get(e.Product2.OcdlaMembershipStatusGrant__c).add(e);
            }
        }
    }
    
    

    
    /**
     * @method 
     */
    public static PricebookEntry lookupMembershipProduct(String memberStatus, Integer barYear){
        PricebookEntry relatedEntry;
        
        
        // if the member status is C or X 
        // or some other non-membership status
        // then throw an invalid membership type exception
        if(null == memberStatus || INVALID_RENEWAL_STATUSES.contains(memberStatus)){
            throw new OcdlaInvalidMembershipStatusException('Could not find a related Product for the given membership status, '+memberStatus);
        }

        // For any status other than 'R' 
        // just fetch the appropriate status
        // otherwise, compare the member's bar year with the minimum bar year
        // for any discounted Regular (R) membership.
		String status = memberStatus == 'A' && barYear != null ? 'R' : memberStatus;
        return getPricebookEntriesByMembershipStatus(status, barYear);
    }
    
    public static PricebookEntry lookupAlreadyRenewed() {
        List<PricebookEntry> entries;

        entries = [SELECT Id, UnitPrice, Product2.Description, Product2.ClickpdxCatalog__LineDescription__c, Product2.Id, Product2.Name, Product2.OcdlaMembershipStatusGrant__c,
                   Product2.OcdlaMinimumBarYearEligibility__c FROM PricebookEntry WHERE IsActive = True AND Product2.Family = :MEMBERSHIP_PRODUCT_FAMILY
                  AND Name = 'Already Renewed' LIMIT 1];
            
		return null == entries ? null : entries[0];
    }

    public static PricebookEntry getPricebookEntriesByMembershipStatus(String status){
		return getPricebookEntriesByMembershipStatus(status,0);
    }
    
    public static PricebookEntry getPricebookEntriesByMembershipStatus(String status, Integer barYearFloor){
        if(null == membershipEntries){
            initMembershipEntries();
        }
        
        List<PricebookEntry> entries = membershipEntries.get(status);
        
        if(entries.size() > 1){
            for(PricebookEntry e : entries){
                if(barYearFloor >= e.Product2.OcdlaMinimumBarYearEligibility__c){
                    return e;
                }
            }
        }
            
        return entries[0];            
    }
    
    

    
    
    
    public class OcdlaInvalidMembershipStatusException extends Exception {}
    
}