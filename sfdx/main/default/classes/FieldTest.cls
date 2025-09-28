@isTest
public class FieldTest {
  
     
    // Test the MultiFieldSetController
    @isTest
    public static void multiFieldSetControllerTest(){
        
        Contact c = new Contact(FirstName = 'Trevor', LastName = 'Uehlin');
        insert c;
        
        MultiFieldSet mfs = new MultiFieldSet('Contact_Information_Basic');
        mfs.buildQuery();
        
        
        mfs.record = c;
        mfs.theFieldSets = 'Contact_Information_Basic';
        
        Component.Apex.PageBlock pageBlock = mfs.getBuildFieldSets();
        
        
    }
    
}