public class ClickpdxCartActionRemoveFromCart {

    public static List<ClickpdxCartItem> doAction(ClickpdxShoppingCart cart, Map<String,Object> params){
        
        ClickpdxCartItem item = new ClickpdxCartItem();
        item.clientId = null != params.get('clientId') ? (String)params.get('clientId') : null;
        item.opportunityLineItemId = (Id)params.get('opportunityLineItemId');
        
		String key = item.key();
        
        cart.removeItem(item);
        
        item.del();

        
        return new List<ClickpdxCartItem>{item};
		
    }
    
}