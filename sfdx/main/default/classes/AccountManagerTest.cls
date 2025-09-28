@isTest(SeeAllData=True)
public class AccountManagerTest {
   
      
    // Test the ProfileController
    @isTest  
    public static void profileControllerTest(){
        
        Contact c = new Contact(FirstName = 'Trevor', LastName = 'Uehlin', Email = 'jbernal.web.dev@gmail.com');
        insert c;
        
        
        AccountManagerController pf = new AccountManagerController();
        
        pf.record = c;
        
        pf.saveRecord();
    }
    
    
    
    
    
    

}