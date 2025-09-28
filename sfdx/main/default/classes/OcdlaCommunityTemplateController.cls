public class OcdlaCommunityTemplateController extends CommunityTemplateController {
    
     
    public Ocdla_Apps__c page {get;private set;}
     
    private static Boolean scriptsDisabled = False;
    
    @RemoteAction  
    public static MenuItem getMenu(){
        return OcdlaCatalogController.getMenu();
    }
    
    @RemoteAction
    public static String getMenuHtml(){
        String menu = [SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt  WHERE DeveloperName  = 'StoreMenu'].ClickpdxCore__Value__c;
        return menu;
    }
    
    public static String getNavMenuHtml(){
		// OcdlaCatalogController.getMenuHtml();
        String navMenu = [SELECT ClickpdxCore__Value__c  FROM ClickpdxCore__CoreConfig__mdt  WHERE DeveloperName  = 'NavMenu'].ClickpdxCore__Value__c; 
        return navMenu;  
    }


      
    
    
    
      
    public OcdlaCommunityTemplateController(){
        super();
        
		page = Ocdla_Apps__c.getOrgDefaults();

        // theSettings = new OcdlaApplicationSettings();


        HtmlStylesheet gFonts = new HtmlStylesheet('css2?family=Raleway:ital,wght@0,100..900;1,100..900&display=swap');
        gFonts.domain = 'fonts.googleapis.com';

        HtmlScript jQuery = new HtmlScript('jquery-1.12.2.min.js');
        jQuery.domain = 'code.jquery.com';
        
        HtmlScript requireJs = new HtmlScript('sites/all/libraries/require.js',cdn);
        // requireJs.setData('main','sites/all/modules/cart/js/main');

        styles.add(gFonts);

       
        styles.add(new HtmlStylesheet('sites/force.com/assets/css/site-base.css',cdn));
        styles.add(new HtmlStylesheet('sites/force.com/assets/css/drawer.css',cdn));
        styles.add(new HtmlStylesheet('sites/all/modules/forms/css/forms.css',cdn));

        if(!scriptsDisabled) {
            scripts.add(jQuery);
            scripts.add(new HtmlScript('sites/all/libraries/jquery-cookie/jquery.cookie.js',cdn));
            scripts.add(new HtmlScript('sites/all/modules/cart/js/OCDLA.js',cdn));
            scripts.add(requireJs);
            scripts.add(new HtmlScript('sites/force.com/assets/js/catalog.js',cdn));
            
            footerScripts.add(new HtmlScript('sites/force.com/assets/js/store.js',cdn));
            footerScripts.add(new HtmlScript('sites/all/modules/cart/js/init.js',cdn));
            footerScripts.add(new HtmlScript('sites/force.com/assets/js/product.js',cdn));
        }
        // scripts.clear();
        // footerScripts.clear();
    }


    public static void disableScripts() {
		OcdlaCommunityTemplateController.scriptsDisabled = True;
		// CommunityTemplateController.footerScripts.clear();
    }  
    
    
}