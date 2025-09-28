@isTest
public class ForceUtilitiesTest {
    static Integer TestBatchSize = 5;
    
    @testSetup static void setup() {
        ClickpdxTest.setup('005');
        //StaticResource r = new StaticResource()
    }
    
    public static testMethod void testCustomerPortalSession(){
       ForceUtilities.getStaticResourceUrl('Modal');
    }
    
    //List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];

}