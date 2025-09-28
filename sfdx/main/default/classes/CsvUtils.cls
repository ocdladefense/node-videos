public without sharing class CsvUtils {
    
     
    private static SObject stdPriceBook;  // Singleton, remember when first referenced
    
    //  -------------------------------------------------------
    //  getStdPriceBook: Singleton
    //  -------------------------------------------------------
    public static Id getStdPriceBookId () {

        if(stdPriceBook == null) {
            if(Test.isRunningTest()) {
                Id tmpId = Test.getStandardPricebookId();
                Schema.SObjectType sobjectType = tmpId.getSObjectType();
                stdPriceBook = sobjectType.newSObject(tmpId);
            }
			else stdPriceBook = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard=True LIMIT 1];
        }
            
        return stdPriceBook.Id;    
    }
    
}