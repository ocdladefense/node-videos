@isTest(SeeAllData=True)
public class ProfileTest {
  
    
    // Test the ProfileController
    @isTest  
    public static void profileControllerTest(){
        
        Contact c = new Contact(FirstName = 'Trevor', LastName = 'Uehlin', Email = 'jbernal.web.dev@gmail.com');
        
        ProfileController pf = new ProfileController();
        
        pf.record = c;
        
        pf.saveRecord();
    }
    
    
    
    
    
    

}