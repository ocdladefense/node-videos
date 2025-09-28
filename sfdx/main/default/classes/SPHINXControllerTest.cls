@isTest
private class SPHINXControllerTest {
    @isTest static void testGetProducts(){
        List<Product2> products = SPHINXController.getProducts();
        System.assert(products != null);
        System.assert(products.size() == 3);
        
    }
    
    @isTest static void testGetString(){
        SPHINXController.myProducts = SPHINXController.getProducts();
        String xmlString = SPHINXController.XMLgen();
        System.assert(xmlString != null);
        System.assert(xmlString.contains('Product1'));
        System.assert(!xmlString.contains('Product2'));
        System.assert(xmlString.contains('HTML Description'));
    }
    
    
    @testSetup static void testData(){
        Product2 myProduct = new Product2();
        myProduct.Name = 'Product1';
        myProduct.Description = 'Description';
        myProduct.IsActive = true;
        myProduct.ClickpdxCatalog__IsOption__c = false;
        insert myProduct;
        
        myProduct = new Product2();
        myProduct.Name = 'Product2';
        myProduct.Description = 'Description';
        myProduct.IsActive = false;
        myProduct.ClickpdxCatalog__IsOption__c = false;
        insert myProduct;
        
        myProduct = new Product2();
        myProduct.Name = 'Product3';
        myProduct.Description = 'Description';
        myProduct.IsActive = true;
        myProduct.ClickpdxCatalog__IsOption__c = true;
        insert myProduct;
        
        myProduct = new Product2();
        myProduct.Name = 'Product4';
        myProduct.ClickpdxCatalog__HtmlDescription__c = 'HTML Description';
        myProduct.IsActive = true;
        myProduct.ClickpdxCatalog__IsOption__c = false;
        insert myProduct;
        
        myProduct = new Product2();
        myProduct.Name = 'Product5';
        myProduct.IsActive = true;
        myProduct.ClickpdxCatalog__IsOption__c = false;
        insert myProduct;
       
    }
}