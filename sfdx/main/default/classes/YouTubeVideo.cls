public without sharing class YouTubeVideo {
    
    public SObject[] chapters {get; set;}
    
    private String cid;
    
    private String eventId;
    
    public Boolean hasAccess = False;
    
    public Boolean isStaff = True;
    
    
    public YouTubeVideo() {
		User u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        
        this.cid = u.ContactId;
        
		Map<String,String> params = ApexPages.currentPage().getParameters();
        
        this.eventId = params.get('id');
        this.isStaff = null != params.get('isStaff') && params.get('isStaff') == 'True' ? True : False;
    }
    
    public Boolean getHasAccess(){
        if(this.isStaff) return True;
        if(null == this.cid) return False;
        
        List<OrderItem> purchasedTickets = [SELECT Id FROM OrderItem WHERE Contact__c = :this.cid AND Product2Id IN (SELECT Id FROM Product2 WHERE Event__c = :this.eventId)];
        
        return null != purchasedTickets && purchasedTickets.size() > 0;
    }
    
    
    
    
    
}