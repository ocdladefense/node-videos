public class OcdlaDonate extends CommunityController {

    public OcdlaDonate(){
        super();
        Map<String,String> params = ApexPages.currentPage().getParameters();
    }

    
    
    public String getDonationFunds(){
        List<PricebookEntry> funds = new List<PricebookEntry>();
        
        funds.addAll([SELECT Id, UnitPrice, Product2.Id, Product2.Name, Product2.Description FROM PricebookEntry WHERE Product2.Family = 'Donation Fund'
                     AND Product2.IsActive = True ORDER BY Product2.ClickpdxCatalog__DisplayOrder__c ]);
        
        return JSON.serializePretty(funds);
    }
    
    public String getToday(){
        
        Date today = System.today();
        String month = String.valueOf(today.month());
        String day = String.valueOf(today.day());
        String year = String.valueOf(today.year());
        
        return (month + '/'+day+'/'+year);
    }

    public String getSampleFirstPaymentDate(){
        Date today = System.today();   
        
        String month = ClickpdxDate.getMonthName(today.month());
        String day = String.valueOf(today.day());
        
        return month + ', '+day;
    }

    
    public String getSampleNextPaymentDate(){
        Date today = System.today();
		Date nextMonthDate = today.addDays(30);   
        
        String month = ClickpdxDate.getMonthName(nextMonthDate.month());
        String day = String.valueOf(nextMonthDate.day());

        return month + ', '+day;
    }
    
    
    
}