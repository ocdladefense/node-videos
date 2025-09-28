public virtual class ClickpdxShoppingCartException extends Exception {
    public ClickpdxCartItem item {public get; public set;}
    
    public void setProduct(ClickpdxCartItem item){
        this.item = item;
    }
    
    public ClickpdxCartItem getProduct(){
        return this.item;
    }
}