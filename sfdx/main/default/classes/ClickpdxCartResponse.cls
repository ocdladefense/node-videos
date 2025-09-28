public class ClickpdxCartResponse {
     
	public Boolean errors = False;
    
    public String errorType = Null;
    
    public String message;
    
    public String[] stackTrace = new String[]{};
    
    public ClickpdxCartItem[] affectedItems = new ClickpdxCartItem[]{};
    
    public ClickpdxCartItem[] cartItems = new ClickpdxCartItem[]{};
    
    public Integer countItems = 0;
    
    public ClickpdxCartResponse(){}
    
    public void attachCart(ClickpdxShoppingCart cart){
        if(null != cart && null !=cart.count()){
            this.countItems = cart.count();
        }
        this.countItems = cart.count();
        this.cartItems = cart.getItems().values();
    }
    
    
    public void addError(Exception e){
        String errorType;
        String message;
        String stackTrace;
        
        this.errors = True;            
        errorType = e.getTypeName();
        message = e.getMessage();
        stackTrace = e.getStackTraceString();
        
		this.errors = True;
        this.errorType = ClickpdxCartResponse.prepareForJson(errorType);
        this.message = ClickpdxCartResponse.prepareForJson(message);
        this.stackTrace.add(ClickpdxCartResponse.prepareForJson(stackTrace));
        System.debug('ClickpdxCartException type caught: ' + e.getTypeName());
    }
    
    public static String prepareForJson(String input){
        
        if(null == input){
            return input;
        }
        
        else return input.replaceAll('\n', '\\\\n');
    }
}