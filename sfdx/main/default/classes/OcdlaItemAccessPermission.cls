public class OcdlaItemAccessPermission {
    public static Id membersOnlyBadge = 'a0dj0000000NQUs';
    
    public static Boolean hasMembersOnlyAccessPermission(OrderApi__Item__c theItem){
        Id existingBadgePermission = null;
        List<OrderApi__Access_Permission__c> itemPermissions = new List<OrderApi__Access_Permission__c>(); 
        // Check if the Item already has the appropriate Access Permission
        itemPermissions = [SELECT Id, ORDERAPI__BADGE_TYPE__C, ORDERAPI__ITEM__C FROM OrderApi__Access_Permission__c
                           WHERE ORDERAPI__ITEM__C = :theItem.Id AND OrderApi__Badge_Type__c = :membersOnlyBadge];
        
        return itemPermissions.size()>0;
    }
    
    public static Id existingMembersOnlyBadgeAccessPermissionId(OrderApi__Item__c theItem){
        Id existingBadgePermission = null;
        List<OrderApi__Access_Permission__c> itemPermissions = new List<OrderApi__Access_Permission__c>(); 
        // Check if the Item already has the appropriate Access Permission
        itemPermissions = [SELECT Id, ORDERAPI__BADGE_TYPE__C, ORDERAPI__ITEM__C FROM OrderApi__Access_Permission__c
                           WHERE ORDERAPI__ITEM__C = :theItem.Id AND OrderApi__Badge_Type__c = :membersOnlyBadge];
        
        if(itemPermissions.size()>0){
            existingBadgePermission = itemPermissions[0].Id;   
        }
        
        return existingBadgePermission;
    }
}