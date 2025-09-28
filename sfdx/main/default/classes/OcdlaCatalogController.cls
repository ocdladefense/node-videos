global class OcdlaCatalogController extends CommunityController {
   
    
    public String catalogName { get; private set;}
    
    public List<CatalogProduct> theProducts { get; private set;}
    
    public Boolean hasProducts { get;private set;}
    
	public static MenuItem rootMenu { get;private set;}
    
    public static String menuHtml { get; private set;}

    
    @RemoteAction    
    public static MenuItem getMenu(){
        rootMenu = new MenuItem();
        return buildMenu(rootMenu);
    }
    
    @RemoteAction
    public static String getMenuHtml(){
        rootMenu = new MenuItem();
        menuHtml = '';
        return '<ul class="menu">'+ buildMenuHtml(rootMenu) + '</ul>';
    }
    
    
    
    @future
    public static void cacheCatalog(){
        ClickpdxCore__CoreConfig__mdt theMenu;
        List<ClickpdxCore__CoreConfig__mdt> components = [SELECT Id, DeveloperName, ClickpdxCore__Value__c
                                                          FROM ClickpdxCore__CoreConfig__mdt WHERE DeveloperName  = 'StoreMenu'];
         
        if(0 == components.size()){
            theMenu = new ClickpdxCore__CoreConfig__mdt();
            theMenu.DeveloperName = 'StoreMenu';
        } else {
            theMenu = components[0];
        }

        // theMenu.ClickpdxCore__Value__c = OcdlaCatalogController.getMenuHtml();
        
        
        Map<String, Object> myMenu = new Map<String, Object>();
        myMenu.put('ClickpdxCore__Value__c', OcdlaCatalogController.getMenuHtml());
        
        Id jobId = null;
        if(!Test.isRunningTest()) {
        	Metadata.DeployContainer container = CustomMetadataUtilities.save('ClickpdxCore__CoreConfig.StoreMenu', 'Store Menu', myMenu);
            jobId = CustomMetadataUtilities.deploy(container);
        }
        
        // return jobId;
    }

    
    
    
    //@RemoteAction
    webservice static CatalogProductList retrieveItems(Id catalogId) {
        CatalogProductList theList;
        
        theList = new CatalogProductList(catalogId);
        // theList.findAll();
        
        return theList;
    }
    
    

    public OcdlaCatalogController(){
        Map<String,String> params;
        List<Product2> ps;
        
        params = ApexPages.currentPage().getParameters();

        
        if(null == params || params.size() == 0 || null == params.get('name')){
        	catalogName = 'Memberships';
        }
        else {
            catalogName = params.get('name');
        }
        
        try {
        	CatalogProductList theList = new CatalogProductList(catalogName);
        	theProducts = theList.items;
	        hasProducts = True;
        } catch(CatalogException e) {
            theProducts = new List<CatalogProduct>();
	        hasProducts = False;
        }
        

    }
    
    

    

    
    
    public static String buildMenuHtml(MenuItem item){
        menuHtml += null == item.catId ? '' : '<li class="menu-item"><a href="#" data-url="'+item.url+'" data-catalog-name="'+item.name+'" data-catalog-id="'+item.catId+'">'+item.name + '</a>';
        
        if(!item.hasChildren()){
            menuHtml +='</li>';
            return menuHtml;
        } else if(null != item.catId){
            menuHtml += '<ul class="menu sub-menu">';
        }
        
        for(MenuItem child :item.getChildren()){
            buildMenuHtml(child);
        }
         
        menuHtml += null == item.catId ? '' : '</ul></li>';
        return menuHtml;
    }
    
    public static MenuItem buildMenu(MenuItem item){
        
        if(!item.hasChildren()){
            return item;
        }
        
        for(MenuItem child :item.getChildren()){
            buildMenu(child);
        }
        
        return item;
    }
    

 

}