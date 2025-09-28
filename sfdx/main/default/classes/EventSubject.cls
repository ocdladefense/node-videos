public without sharing class EventSubject implements ISubject {

    public String subjectId;
    
    
    
    public EventSubject(){}
    
    public EventSubject(String subjectId) {
        this.subjectId = subjectId;
    }
     
    
    public SObject getInfo() {
        String subjectId = this.subjectId;
        String query = 'SELECT Id, Name, Is_Active__c, Include_In_Catalog__c, DisabledRegistrationInstructions__c'
			+ ', RegistrationInstructions__c, Registration_Enabled__c, Overview__c, Venue__c, Agenda__c, Start_Date__c, End_Date__c'
			+ ', Banner_Date_Text__c, Banner_Location_Text__c, Early_Bird_End_Date__c, Image_Thumbnail_Url__c '
			+ 'FROM Event__c WHERE Id = :subjectId';
        return Database.query(query);
    }
     
    
    public SObject[] getItems() {
		String query = 'SELECT Id, Name, Order__c, Published__c, Date__c,'
            +' Speakers__c, ResourceId__c, Description__c FROM Media__c' +
            ' WHERE Event__c = :subjectId ORDER BY Order__c NULLS LAST'; 
        
		return Database.query(query);
    }
    
    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId;
    }
    
    
}