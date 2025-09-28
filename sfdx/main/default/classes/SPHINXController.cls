public class SPHINXController {
	 public static List<Product2> myProducts = new List<Product2>();
    public static string xmlString {public get; private set;}
    public static DOM.Document doc {public get; private set;}
    
    public SPHINXController(){
        myProducts = getProducts();
        xmlString = XMLGen();
    }
    
    public static List<Product2> getProducts(){
        return [Select Id, Name, Description, ClickpdxCatalog__HtmlDescription__c, IsActive 
                      From Product2 where IsActive = true and ClickpdxCatalog__IsOption__c = false];
    } 
    
    public static string XMLgen(){
        doc = new DOM.Document();
        dom.XmlNode products = 
            doc.createRootElement('sphinx:docset', null, null); 
        dom.XmlNode schema = 
            products.addChildElement('sphinx:schema', null, null); 
        dom.XmlNode fieldOne =
            schema.addChildElement('sphinx:field', null, null);
        fieldOne.setAttribute('name', 'subject');
        dom.XmlNode fieldTwo =
            schema.addChildElement('sphinx:field', null, null);
        fieldTwo.setAttribute('name', 'content');
        dom.XmlNode fieldThree =
            schema.addChildElement('sphinx:field', null, null);
        fieldThree.setAttribute('name', 'product_name');
        dom.XmlNode attrOne =
            schema.addChildElement('sphinx:attr', null, null);
        attrOne.setAttribute('name', 'product_id');
        attrOne.setAttribute('type', 'string');
        dom.XmlNode attrTwo =
            schema.addChildElement('sphinx:attr', null, null);
        attrTwo.setAttribute('name', 'published');
        attrTwo.setAttribute('type', 'timestamp');
        dom.XmlNode attrThree =
            schema.addChildElement('sphinx:attr', null, null);
        attrThree.setAttribute('name', 'author_id');
        attrThree.setAttribute('type', 'int');
        attrThree.setAttribute('bits', '16');
        attrThree.setAttribute('default', '1');
            
        integer counter = 1;
        for(Product2 prod : myProducts){
            System.debug(prod);
            dom.XmlNode body = 
                products.addChildElement('sphinx:document', null, null);
            body.setAttribute('id', string.valueOf(counter));
            body.addChildElement('product_id', null, null).addTextNode(prod.Id);
            body.addChildElement('product_name', null, null).addTextNode(prod.Name);
            if(prod.Description != null)
            {
                body.addChildElement('content', null, null).addTextNode(prod.Description);
            }
            else if(prod.ClickpdxCatalog__HtmlDescription__c != null)
            {
                body.addChildElement('content', null, null).addTextNode(prod.ClickpdxCatalog__HtmlDescription__c);
            }
            else
            {
                body.addChildElement('content', null, null).addTextNode(' ');
            }
            counter++;
        }
        return doc.toXmlString();
        
    }
}