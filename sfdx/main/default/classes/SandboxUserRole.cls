public class SandboxUserRole {

    private String userRoleName;
    
	private UserRole portalRole;
    
    public static final String DEFAULT_USER_ROLE_NAME = 'My Custom Role';
    
    
    public SandboxUserRole() {
		this(DEFAULT_USER_ROLE_NAME);
    }
    
    public SandboxUserRole(String userRoleName) {
        this.userRoleName = userRoleName;
		String developerName = this.userRoleName.replace(' ','');
        
        List<UserRole> roles = [SELECT Id, DeveloperName, Name FROM UserRole WHERE DeveloperName = :developerName LIMIT 1];
        
        portalRole = null == roles || roles.size() == 0 ? null : roles[0];
        
        if(null == portalRole) {
            portalRole = createSObject();
        }  
    }
        
    
    public UserRole createSObject() {
		String developerName = this.userRoleName.replace(' ','');
        return new UserRole(DeveloperName = developerName, Name = this.userRoleName, PortalType='None' );  
    }
        
    
    public UserRole insertSObject() {

        if(null == portalRole.Id) {
            insert portalRole;
        }
        else {
            update portalRole;
        }

        return portalRole;
    }
    
}