public class MembersOnlyAccess {

    public static Boolean hasAccess(ClickpdxCartItem item){
        
        if(!isMembersOnly(item)){
            return True;
        } else {
           	return isUserCurrentMember(UserInfo.getUserId());
        }
    }
    
    @TestVisible
    private static Boolean isMembersOnly(ClickpdxCartItem item){
        Id product2Id = [SELECT Product2Id FROM PricebookEntry WHERE Id = :item.pricebookEntryId].Product2Id;
        
        Product2 prod = [SELECT ClickpdxCatalog__IsMembersOnly__c FROM Product2 WHERE Id = :product2Id];
        
        return prod.ClickpdxCatalog__IsMembersOnly__c;
    }
    
    public static Boolean isUserCurrentMember(Id userId){
		User currentUser = [SELECT ContactId FROM User WHERE Id = :userId];
        if(null == currentUser.ContactId){
            return False;
        }
        Contact c = [SELECT Id, Ocdla_Current_Member_Flag__c FROM Contact WHERE Id = :currentUser.ContactId];
        return c.Ocdla_Current_Member_Flag__c;
    }
    
}