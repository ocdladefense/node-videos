public class OcdlaTemplateStoreController {

    OcdlaApplicationSettings theSettings {get;private set;}
    
    public User currentUser {get;private set;}
    
    public Stylesheet[] styles {get;private set;}
    
    public Script[] scripts {get;private set;}
    
    public Script[] footerScripts {get;private set;}
    
    public Ocdla_Apps__c page {get;private set;}
    
    public String domain {get;private set;}
    
    public String cacheKey {get;private set;}
    
    public String communityProfileName {get;private set;}
    
    private static String PROTO = 'https';
     
    private static String THE_DOMAIN;
    
    @RemoteAction
    public static Object getMenu(){
        //return OcdlaCatalogController.getMenu();
        //return CatalogMenuGenerator.getMenu();
        return null;
    }
    
    @RemoteAction
    public static String getMenuHtml(){
        String menu = [SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt  WHERE DeveloperName  = 'StoreMenu'].ClickpdxCore__Value__c;
        return menu;
    }
    
    public static String getNavMenuHtml(){
        String navMenu = [SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt  WHERE DeveloperName  = 'NavMenu'].ClickpdxCore__Value__c; //OcdlaCatalogController.getMenuHtml();
        return navMenu;  
    }
    
    public String getLoginUrl(){
        return null != theSettings.loginUrl ? theSettings.loginUrl : '//auth.ocdla.org/login1.php?retURL=https%3A%2F%2Focdla.force.com%2FVideos%3Fid%3Da230a00000J5WWtAAN';
    }
    
    public String getLogoutUrl(){
        return null != theSettings.logoutUrl ? theSettings.logoutUrl : '//auth.ocdla.org/logoutAms';
    }
    
    public String getProfileUrl(){
		return null != theSettings.profileUrl ? theSettings.profileUrl : '/CPBase__profile';
    }
    
    public OcdlaTemplateStoreController(){
		page = Ocdla_Apps__c.getOrgDefaults();

        theSettings = new OcdlaApplicationSettings();
        
        domain = page.Ocdla_Force_Use_of_Test_Server__c ? page.Ocdla_Test_Application_Server__c : page.Ocdla_Production_Application_Server__c;
        cacheKey = page.Ocdla_Cache_Random__c;
        
        communityProfileName = theSettings.COMMUNITY_PROFILE_NAME;//(String)ClickpdxCore.Application.config.get('COMMUNITY_PROFILE_NAME ');
        
        
        currentUser = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId()];
        
        
        THE_DOMAIN = domain;
        Stylesheet gFonts = new Stylesheet('css?family=Raleway');
        gFonts.domain = 'fonts.googleapis.com';
        
        
        Script jQuery = new Script('jquery-1.12.2.min.js');
        jQuery.domain = 'code.jquery.com';
        
        Script requireJs = new Script('sites/all/libraries/require.js');
        // requireJs.setData('main','sites/all/modules/cart/js/main');
        
        styles = new Stylesheet[]{};
        scripts = new Script[]{};
        footerScripts = new Script[]{};
        styles.add(gFonts);

        
        styles.add(new Stylesheet('sites/force.com/assets/css/site-base.css'));
        styles.add(new Stylesheet('sites/force.com/assets/css/drawer.css'));
        styles.add(new Stylesheet('sites/all/modules/forms/css/forms.css'));

        scripts.add(jQuery);
        scripts.add(new Script('sites/all/libraries/jquery-cookie/jquery.cookie.js'));
        scripts.add(new Script('sites/all/modules/cart/js/OCDLA.js'));
        scripts.add(requireJs);
       	scripts.add(new Script('sites/force.com/assets/js/catalog.js'));
        
        footerScripts.add(new Script('sites/force.com/assets/js/store.js'));
        footerScripts.add(new Script('sites/all/modules/cart/js/init.js'));
    }

    public Boolean getIsUserLoggedIn(){
    	Id currentUserProfileId;
        String currentProfileName;

        
        
        currentUserProfileId = UserInfo.getProfileId();
        
        currentProfileName = [SELECT Name FROM Profile WHERE Id = :currentUserProfileId].Name;
        
        
        return currentProfileName != this.communityProfileName;
    }
    
    public class Stylesheet {
        
        public String proto {get;set;}
        
        public String domain {get;set;}
        
        public String url {get;set;}
        
        public Stylesheet(String url){
            this.proto = OcdlaTemplateStoreController.PROTO;
            this.domain = OcdlaTemplateStoreController.THE_DOMAIN;
            this.url = url;
        }
        
    }
    
    public class Script {
        
        public String proto {get;set;}
        
        public String domain {get;set;}
        
        public String url {get;set;}
        
        public String dataMain {get;set;}
        
        public Script(String url){
            this.proto = OcdlaTemplateStoreController.PROTO;
            this.domain = OcdlaTemplateStoreController.THE_DOMAIN;
            this.url = url;
            this.dataMain = '';
        }
        
        public void setData(String dataKey, String dataValue){
            this.dataMain = '//'+this.domain+'/'+dataValue;
        }  
        
    }
    
    
}