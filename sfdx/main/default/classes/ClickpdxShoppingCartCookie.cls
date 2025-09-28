public class ClickpdxShoppingCartCookie {
    
    public static PageReference invalidateShoppingCartCookie(String cartId){
        Cookie shoppingCartId;
    
        shoppingCartId = new Cookie('shoppingCartId', cartId, null, 0, False);
    
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{shoppingCartId});
        
        return null;
    }
    
    public static void setShoppingCartId(Id oppId) {
        Cookie shoppingCartId;
    	Integer THIRTY_DAYS = 86400 * 30;
        shoppingCartId = new Cookie('shoppingCartId', oppId == null ? '' : (String)oppId, null, THIRTY_DAYS, False);
    
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{shoppingCartId});
    }
    
    public static Id getShoppingCartId() {
        Cookie shoppingCartId = ApexPages.currentPage().getCookies().get('shoppingCartId');
        if(null == shoppingCartId) {
            return null;
        }
        return (Id)shoppingCartId.getValue();
    }
    

}