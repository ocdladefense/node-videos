@isTest
public class AwsS3PostRequestControllerTest {
    

    
    @isTest
    private static void doTest() {
        
        // Sample base64 data; note this isn't valid data and has been truncated.
        String ocdlaLogo = 'iVBORw0KGgoAAAANSUhEUgAAAhUAAACVCAYAAADvywiPAAAAAXNSR0IArs4c6QAAAFBlWElmTU0AKgAAAAgAAgES'+
            'AAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAACFaADAAQAAAABAAAAlQAAAACu9OcBAAABWWlUWHRYTUw6Y29tLmFkb2Jl'+
            'LnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY'+
            '9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgI'+
            'CB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAg';
        Test.startTest();
        
        // The Mock is really just responsible for returning 200 Ok for a PUT request.
        FieldEditorHttpMock mock = new FieldEditorHttpMock();
        Test.setMock(HttpCalloutMock.class, mock);

        AwsS3PostRequestController c;
        PageReference thePage = Page.AwsS3PostRequest;
        
        
        Map<String,String> params = thePage.getParameters();
        params.put('file', 'ocdlaLogo.png');
        params.put('data', ocdlaLogo);
        params.put('mimeType', 'image/png');
        

        
        Test.setCurrentPage(thePage);
        c = new AwsS3PostRequestController();  
        

        Test.stopTest();
        

        
        FieldEditorException e = new FieldEditorException('There was an error.');
    }
    
}