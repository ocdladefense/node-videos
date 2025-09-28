public class SandboxEnvironment {

    
    public static Boolean hasCommunityLicenses() {
        
        //  this.hasCommunityLicense = True;
        return True;
    }
           
    public static String getCommunityDomain() {
       
        Network n1; 
        Network n2;
        Url baseUrl;
        String baseDomain;
        
        try {
			n1 = [SELECT Id, Name, UrlPathPrefix FROM Network WHERE Name = 'OCDLA Member Community'];
        } catch(System.QueryException e) {
            
        }
	
        if(null == n1) {
            return '';
        }
        
        
        String loginUrl = Network.getLoginUrl(n1.Id);
        
        
    	baseUrl = new Url(loginUrl);
        
        

        return baseUrl.getAuthority();
      
    }
    
    public static List<Profile> getAvailableProfiles() {
        

            List<Profile> profiles = Test.isRunningTest() ? [SELECT Id, Name, UserType FROM Profile] : null;
        
        return profiles;

    }
    
    public static Profile getSystemAdministratorProfile() {
		return [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    }
    
    public static User getSystemAdministrator() {
        return [SELECT Id, Name FROM User WHERE FirstName='System' AND LastName='Administrator' AND IsActive = True LIMIT 1];
    }
    
    public static Profile getCustomerProfile() {
        
        
        //CspLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        // Set<String> customerUserTypes = new Set<String> {'Fonteva Customer Community Login User'};
        
        
        
        List<Profile> availableProfiles = [SELECT Id FROM Profile WHERE Name = 'MN Customer Community Login User'];

        
        if(null == availableProfiles || availableProfiles.size() < 1) {
            availableProfiles = [SELECT Id FROM Profile WHERE Name = 'Authenticated Website'];
        }
        
        return availableProfiles[0];
    }

}