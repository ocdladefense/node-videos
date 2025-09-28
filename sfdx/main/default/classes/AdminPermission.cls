public class AdminPermission implements IPermission {

    // Determine permission based on the current User's profile.
    public static Boolean hasPermission(Map<String,Object> params) {
        
        Id contactId = (Id)params.get('contactId');
        
        List<String> adminProfiles = new List<String>{
            'Fonteva Standard User',
			'Fonteva Standard Platform User',
			'System Administrator',
			'MN Standard User',
			'Standard User',
			'MN Standard Platform User',
			'Standard Platform User'
        };

            
        // Query for the User linked to this contact
        User user = [
            SELECT Id, Profile.Name
            FROM User
            WHERE ContactId = :contactId
            LIMIT 1
        ];

        return adminProfiles.contains(user.Profile.Name);
        
        //Set<Id> fullAccess = new Map<Id,Profile>([SELECT Id FROM Profile WHERE Name = :adminProfiles AND Id = :UserInfo.getProfileId()]).keySet();
                   
		//return null != fullAccess && fullAccess.size() > 0;
    }
}