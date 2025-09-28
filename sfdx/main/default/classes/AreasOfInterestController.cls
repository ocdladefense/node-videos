public without sharing class AreasOfInterestController {

        public Contact theContact;
    
        public AreaOfInterest__c del;

        public List<AreaOfInterest__c> aoiList {get;set;}
    
        public List<AreaOfInterest__c> addList {get;set;}
    
        public List<AreaOfInterest__c> delList {get;set;}
        
        public Integer totalCount {get;set;}
    
        public Integer rowIndex {get;set;}
    
        public List<AreaOfInterest__c> delAois {get;set;}
    
    

        public AreasOfInterestController() {
                // theContact = (Contact)controller.getRecord();
				Id contactId = ApexPages.currentPage().getParameters().get('id');
            
            if(null == contactId) {
                User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
                contactId = u.ContactId;
            }
            	theContact = [SELECT Id, FirstName, LastName FROM Contact WHERE Id = :contactId];
                aoiList = [SELECT Id, Interest__c FROM AreaOfInterest__c WHERE Contact__c = :contactId];
                totalCount = aoiList.size();
                addList = new List<AreaOfInterest__c>();
                delList = new List<AreaOfInterest__c>();
        }

        public void addRow() {
            // addContactList = new List < Contact > ();
            aoiList.add(new AreaOfInterest__c(Contact__c = theContact.Id));
        }
    
        public void addRow(String interest) {
            aoiList.add(new AreaOfInterest__c(Contact__c = theContact.Id, Interest__c = interest));
        }


    
        public void deleteRow() {
                rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
                del = aoiList.remove(rowIndex);
                delList.add(del);
        }
    
        public PageReference save() {
                upsert aoiList;
                delete delList;
                //return (new ApexPages.StandardController(accounts)).view();
                PageReference pageRef = new PageReference('/apex/ProfileAreasOfInterest');
				apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Your changes were saved.'));
                pageRef.getParameters().put('id',theContact.Id);
                return pageRef;
        }
    
        public PageReference cancel() {
                PageReference pageRef = new PageReference('/apex/ProfileAreasOfInterest');
                pageRef.getParameters().put('id',theContact.Id);
                return pageRef;
        }
}