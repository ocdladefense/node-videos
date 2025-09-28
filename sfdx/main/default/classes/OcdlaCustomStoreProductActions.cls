global class OcdlaCustomStoreProductActions extends ClickpdxStore.ProductController.ProductActions {
    
    public OcdlaCustomStoreProductActions(){
        super(new Map<String,Object>{
            'productQuery' => setProductQuery(),
            'lineQuery' => null //setLineItemQuery() Later we can query to see if the customer has actually purchased this product
        });
    }

    @TestVisible
    private static String[] setProductQuery(){
        String[] fields = new String[]{'Id','Name','ProductCode','Description','ClickpdxCatalog__HtmlDescription__c'};
        return fields;
    }
    
}