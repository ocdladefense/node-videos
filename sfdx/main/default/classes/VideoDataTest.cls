@isTest
public class VideoDataTest {
    

    
    @isTest
    private static void doTest() {
        

        Test.startTest();
        
        // The Mock is really just responsible for returning 200 Ok for a PUT request.
        FieldEditorHttpMock mock = new FieldEditorHttpMock();
        Test.setMock(HttpCalloutMock.class, mock);

        VideoData c;
        PageReference thePage = Page.VideoData;
        
        
        Map<String,String> params = thePage.getParameters();
        // params.put('file', 'ocdlaLogo.png');
        

        
        Test.setCurrentPage(thePage);
        c = new VideoData();  
        
        String responseBody = c.getResponseBody();

        Test.stopTest();
    }
    
}