@isTest
public class VideoAppTests {
    
    private static String recordPrefix = 'TEST001';
    
    public Event__c evt;
       
    public Account a;
     
    public Product2 p;
    
    public Contact c;
     
	public Media__c video;
     
     
    
    @testSetup static void setup() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
		ClickpdxTest.setup(recordPrefix); 
    }
	
    
    
	@isTest
    static void loadVideoAppForEvent() {
        // Variable initialization.
		VideoAppTests context = new VideoAppTests();
    
         
        Test.startTest(); 
        
        if(null == context.evt || null == context.evt.Id) throw new System.AssertException('TEST_INITIALIZATION_ERROR: The event id was NULL.');
 
        PageReference video = Page.Videos;
        video.getParameters().put('id', context.video.Id);
        Test.setCurrentPage(video);
    
        VideoApp c = new VideoApp();
          
        // c.loadEvent();
 		VideoApp.getHasAccess(context.video.ResourceId__c);
        VideoApp.getAssets(context.evt.Id);
        c.getSubjects();
        
        EventSubject sub = new EventSubject(context.evt.Id);
        sub.getInfo();
        
        Test.stopTest();
    }
    
    
    
     
    public VideoAppTests() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        this.a = [SELECT Id, Name FROM Account WHERE Name = :recordPrefix LIMIT 1];
        this.c = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 1];

        
        this.evt = new Event__c(Name='My custom event');
        this.evt.Start_Date__c = System.today();
        this.evt.Early_Bird_End_Date__c = System.today()+10;
        this.evt.Start_Date__c = System.today();
        this.evt.Include_In_Catalog__c = True;
        insert this.evt;
        
        Chapter__c chapter = new Chapter__c(Name='My custom chapter',Title__c = 'My custom title');
        chapter.Event__c = this.evt.Id;
        chapter.PublishVideo__c = True;
        chapter.VideoURL__c = 'YT-random-id';
        
        insert chapter;
        
        
        this.p = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name LIKE :filter LIMIT 1];
        this.p.OcdlaEligibleMemberStatuses__c = 'R,N,A,S,L,T,LL';
        this.p.Chapter__c = chapter.Id;
        this.p.Event__c = this.evt.Id;
        
        update this.p;
        
        this.video = new Media__c(Name = 'Test Video', Event__c = this.evt.Id, Chapter__c = chapter.Id, ResourceId__c = chapter.VideoUrl__c);
        
        insert this.video;
        
        VideoAppException e = new VideoAppException('MISSING_RESOURCE_ID');
    }
    
}