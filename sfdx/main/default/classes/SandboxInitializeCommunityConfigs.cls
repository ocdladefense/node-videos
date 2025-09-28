public class SandboxInitializeCommunityConfigs {

    
    
    public static void updateCommunityConfig() {
        
		EntityConfiguration config = new EntityConfiguration('CommunityConfig');
        config.getConfig();
        
        config.put('Foo','bar');
        String serialized = config.toJson();
        
        String cdn = (String)config.get('cdn');
        String cacheKey = (String)config.get('cacheKey');
        String communityProfileName = (String)config.get('communityProfileName');
    }
    
    
    public static void updateCheckoutConfig() {
        
		EntityConfiguration config = new EntityConfiguration('CheckoutCommunityConfig');
    }
    
    

}